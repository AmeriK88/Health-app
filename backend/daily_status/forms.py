from django import forms
from .models import DailyStatus

class DailyStatusForm(forms.ModelForm):
    class Meta:
        model = DailyStatus
        fields = ['energy_level', 'has_pain', 'is_tired', 'mood', 'notes']
        widgets = {
            'energy_level': forms.Select(attrs={'class': 'form-control'}),
            'has_pain': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
            'is_tired': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
            'mood': forms.Select(attrs={'class': 'form-control'}),
            'notes': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
        }
        labels = {
            'energy_level': 'Nivel de energía',
            'has_pain': '¿Tienes dolor?',
            'is_tired': '¿Estás cansado?',
            'mood': 'Estado de ánimo',
            'notes': 'Notas adicionales (opcional)',
        }
