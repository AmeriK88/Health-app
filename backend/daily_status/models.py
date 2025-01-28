# -*- coding: utf-8 -*-
from django.db import models
from django.conf import settings

class DailyStatus(models.Model):
    ENERGY_LEVEL_CHOICES = [
        ('low', 'Bajo'),
        ('medium', 'Medio'),
        ('high', 'Alto'),
    ]

    MOOD_CHOICES = [
        ('bad', 'Mal'),
        ('neutral', 'Neutral'),
        ('good', 'Bien'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="daily_statuses")
    date = models.DateField(auto_now_add=True)
    energy_level = models.CharField(max_length=10, choices=ENERGY_LEVEL_CHOICES)
    has_pain = models.BooleanField(default=False)
    is_tired = models.BooleanField(default=False)
    mood = models.CharField(max_length=10, choices=MOOD_CHOICES)
    notes = models.TextField(blank=True)

    class Meta:
        unique_together = ('user', 'date')
        verbose_name = "Estado Diario"
        verbose_name_plural = "Estados Diarios"
        ordering = ['-date']

    def recommend_exercises(self):
        """
        Genera recomendaciones de ejercicios personalizadas según el estado del usuario.
        """
        if self.energy_level == 'low':
            if self.has_pain:
                return "Te recomendamos descansar y realizar estiramientos suaves enfocados en aliviar el dolor."
            elif self.is_tired:
                return "Prioriza el descanso activo, como caminatas ligeras, ejercicios relajantes y estiraminentos."
            else:
                return "Un poco de yoga relajante puede ayudarte a mejorar tu estado general."

        elif self.energy_level == 'medium':
            if self.mood == 'bad':
                return "Realiza ejercicios moderados como pilates o una caminata rápida para mejorar tu ánimo."
            elif self.is_tired:
                return "Opta por ejercicios ligeros como estiramientos o yoga y meditación para reponer tu energía."
            else:
                return "Prueba ejercicios de fuerza moderada o una sesión corta de cardio."

        elif self.energy_level == 'high':
            if self.has_pain:
                return "Aunque tienes mucha energía, escucha a tu cuerpo y evita ejercicios intensos. Prueba estiramientos suaves."
            elif self.is_tired:
                return "Tu energía es alta, pero el cansancio es un indicador. Haz ejercicios moderados y evita sobrecargarte."
            elif self.mood == 'good':
                return "¡Es un momento perfecto para un entrenamiento completo o de alta intensidad!"
            else:
                return "Aprovecha para realizar actividades deportivas que disfrutes, como la escalada o nadar."

        return "Descansa o consulta a un especialista si no te sientes bien."

    def __str__(self):
        return f"Estado de {self.user.username} - {self.date}"

