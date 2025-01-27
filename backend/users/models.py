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
        Incluye validaciones para datos fuera de rango plausible y análisis para casos extremos.
        """
        if self.weight and self.height:
            # Validaciones para rangos de altura y peso
            if self.height < 50 or self.height > 250:
                return "Altura fuera de rango válido"
            if self.weight < 20 or self.weight > 300:
                return "Peso fuera de rango válido"

            # Cálculo del IMC
            bmi = self.weight / ((self.height / 100) ** 2)

            # Clasificación del estado físico
            if bmi < 16:
                return "Desnutrición severa"
            elif 16 <= bmi < 18.5:
                return "Muy baja forma"
            elif 18.5 <= bmi < 24.9:
                return "Forma óptima"
            elif 25 <= bmi < 29.9:
                return "Baja forma"
            elif 30 <= bmi < 34.9:
                return "Obesidad moderada"
            elif 35 <= bmi < 39.9:
                return "Obesidad severa"
            else:  # bmi >= 40
                return "Obesidad mórbida"
        return "Datos insuficientes"

    def __str__(self):
        return self.username
