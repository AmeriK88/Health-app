# daily_status/forms.py
from django import forms
from .models import DailyStatus

class DailyStatusForm(forms.ModelForm):
    class Meta:
        model = DailyStatus
        fields = ['energy_level', 'pain', 'tiredness', 'mood', 'notes']
        widgets = {
            'energy_level': forms.Select(attrs={'class': 'form-control'}),
            'pain': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
            'tiredness': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
            'mood': forms.Select(attrs={'class': 'form-control'}),
            'notes': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
        }
        labels = {
            'energy_level': 'Nivel de energía',
            'pain': '¿Tienes dolor?',
            'tiredness': '¿Estás cansado?',
            'mood': 'Estado de ánimo',
            'notes': 'Notas adicionales (opcional)',
        }
