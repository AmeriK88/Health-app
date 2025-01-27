from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .models import DailyStatus
from .serializers import DailyStatusSerializer

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
            serializer.save(user=request.user)  # Asocia al usuario autenticado
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
