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
        if self.energy_level == 'low' or self.has_pain:
            return "Recomendamos estiramientos suaves y caminatas ligeras."
        elif self.energy_level == 'medium':
            return "Puedes probar yoga o ejercicios de fuerza moderada."
        elif self.energy_level == 'high' and not self.is_tired:
            return "¡Es un buen día para un entrenamiento completo o cardio intenso!"
        return "Descansa o consulta a un especialista si no te sientes bien."

    def __str__(self):
        return f"Estado de {self.user.username} - {self.date}"
