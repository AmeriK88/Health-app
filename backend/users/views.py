# users/views.py
import logging
from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from .models import CustomUser
from .serializers import UserSerializer

logger = logging.getLogger('django')

class RegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    permission_classes = [AllowAny]
    serializer_class = UserSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            logger.info(f"Usuario registrado: {user.username}")
            return Response(
                {"message": "Usuario registrado con éxito."},
                status=status.HTTP_201_CREATED
            )
        else:
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
            data = {
                "username": user.username,
                "age": user.age,
                "bio": user.bio,
                "weight": user.weight,
                "height": user.height,
                "goal": user.goal,
                "avatar": user.avatar.url if user.avatar else None,
                "physical_state": user.calculate_physical_state(),
            }
            logger.info(f"Datos del dashboard obtenidos para {user.username}")
            return Response(data, status=status.HTTP_200_OK)
        except Exception as e:
            logger.error(f"Error al obtener datos del dashboard para {user.username}: {str(e)}")
            return Response(
                {"error": "No se pudieron obtener los datos del usuario."},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
        
    def put(self, request):
        user = request.user
        data = request.data

        # Actualizamos los datos del usuario si están presentes en la solicitud
        user.weight = data.get('weight', user.weight)
        user.height = data.get('height', user.height)
        user.goal = data.get('goal', user.goal)

        # Si hay un archivo 'avatar', lo actualizamos
        if 'avatar' in request.FILES:
            user.avatar = request.FILES['avatar']

        user.save()
        logger.info(f"Datos actualizados para {user.username}")
        return Response(
            {"message": "Datos actualizados con éxito"},
            status=status.HTTP_200_OK,
        )
