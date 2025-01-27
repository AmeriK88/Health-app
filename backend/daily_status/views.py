from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .models import DailyStatus
from .serializers import DailyStatusSerializer
from datetime import date

class DailyStatusView(APIView):
    permission_classes = [IsAuthenticated]  # Requiere autenticación

    def get(self, request):
        """
        Devuelve los estados diarios del usuario autenticado.
        """
        statuses = DailyStatus.objects.filter(user=request.user).order_by('-date')
        serializer = DailyStatusSerializer(statuses, many=True)
        return Response(serializer.data)

    def post(self, request):
        """
        Crea un nuevo estado diario.
        """
        serializer = DailyStatusSerializer(data=request.data)
        if serializer.is_valid():
            # Verificar si ya existe un estado diario para el usuario y la fecha actual
            if DailyStatus.objects.filter(user=request.user, date=date.today()).exists():
                return Response(
                    {"detail": "Ya existe un estado diario para esta fecha."},
                    status=status.HTTP_400_BAD_REQUEST
                )
            # Si no existe, se guarda el nuevo estado
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)