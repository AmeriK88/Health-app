# users/forms.py
from django import forms
from .models import CustomUser

class CustomUserForm(forms.ModelForm):
    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password', 'age', 'weight', 'height', 'goal']
        widgets = {
            'password': forms.PasswordInput(),
        }
