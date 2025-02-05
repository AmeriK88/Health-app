import logging
from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from daily_status.models import DailyStatus  
from daily_status.serializers import DailyStatusSerializer  
from .models import CustomUser
from .serializers import UserSerializer
from django.http import JsonResponse

logger = logging.getLogger('django')

class RegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    permission_classes = [AllowAny]
    serializer_class = UserSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            print(f"✅ Usuario registrado: {user.first_name} {user.last_name}")
            logger.info(f"Usuario registrado: {user.username}")
            return Response(
                {"message": "Usuario registrado con éxito."},
                status=status.HTTP_201_CREATED
            )
        else:
            print(f"❌ Errores en el registro: {serializer.errors}")
            logger.error(f"Errores al registrar usuario: {serializer.errors}")
            return Response(
                {"errors": serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )



class UserDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        try:
            # Obtenemos los estados diarios del usuario
            daily_statuses = DailyStatus.objects.filter(user=user).order_by('-date')
            daily_statuses_serialized = DailyStatusSerializer(daily_statuses, many=True).data

            # Datos del usuario
            data = {
                "username": user.username,
                "age": user.age,
                "bio": user.bio,
                "weight": user.weight,
                "height": user.height,
                "goal": user.goal,
                "avatar": request.build_absolute_uri(user.avatar.url) if user.avatar else None,
                "physical_state": user.calculate_physical_state(),
                "daily_statuses": daily_statuses_serialized, 
            }
            logger.info(f"Datos del dashboard obtenidos para {user.username}")
            # Aseguramos que los caracteres especiales se gestionen correctamente
            return JsonResponse(data, json_dumps_params={'ensure_ascii': False}, status=200)
        except Exception as e:
            logger.error(f"Error al obtener datos del dashboard para {user.username}: {str(e)}")
            return JsonResponse(
                {"error": "No se pudieron obtener los datos del usuario."},
                json_dumps_params={'ensure_ascii': False},
                status=500,
            )

    def put(self, request):
        user = request.user
        data = request.data

        user.weight = data.get('weight', user.weight)
        user.height = data.get('height', user.height)
        user.goal = data.get('goal', user.goal)

        if 'avatar' in request.FILES:
            user.avatar = request.FILES['avatar']

        user.save()
        logger.info(f"Datos actualizados para {user.username}")
        return JsonResponse(
            {"message": "Datos actualizados con éxito"},
            json_dumps_params={'ensure_ascii': False},
            status=200,
        )

