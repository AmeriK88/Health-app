# users/models.py
from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    age = models.PositiveIntegerField(null=True, blank=True)
    bio = models.TextField(blank=True)
    weight = models.FloatField(null=True, blank=True, help_text="Peso en kilogramos")
    height = models.FloatField(null=True, blank=True, help_text="Altura en centímetros")
    goal = models.CharField(max_length=255, blank=True, help_text="Objetivo personal")
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True)

    def calculate_physical_state(self):
        """
        Calcula el estado físico del usuario basado en el IMC (Índice de Masa Corporal).
        """
        if self.weight and self.height:
            bmi = self.weight / ((self.height / 100) ** 2)  # Fórmula del IMC
            if bmi < 18.5:
                return "Muy baja forma"
            elif 18.5 <= bmi < 24.9:
                return "Forma óptima"
            elif 25 <= bmi < 29.9:
                return "Baja forma"
            else:
                return "Forma élite"
        return "Datos insuficientes"

    def __str__(self):
        return self.username
