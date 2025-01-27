from django.db import models
from django.conf import settings

class DailyStatus(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    date = models.DateField(auto_now_add=True)
    energy_level = models.CharField(max_length=10, choices=[
        ('low', 'Bajo'),
        ('medium', 'Medio'),
        ('high', 'Alto')
    ])
    pain = models.BooleanField(default=False)
    tiredness = models.BooleanField(default=False)
    mood = models.CharField(max_length=10, choices=[
        ('bad', 'Mal'),
        ('neutral', 'Neutral'),
        ('good', 'Bien')
    ])
    notes = models.TextField(blank=True)

    def recommend_exercises(self):
        if self.energy_level == 'low' or self.pain:
            return "Recomendamos estiramientos suaves y caminatas ligeras."
        elif self.energy_level == 'medium':
            return "Puedes probar yoga o ejercicios de fuerza moderada."
        elif self.energy_level == 'high' and not self.tiredness:
            return "¡Es un buen día para un entrenamiento completo o cardio intenso!"
        return "Descansa o consulta a un especialista si no te sientes bien."

    def __str__(self):
        return f"Estado de {self.user.username} - {self.date}"
