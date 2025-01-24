# users/serializers.py
from rest_framework import serializers
from .models import CustomUser

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = [
            'id', 'username', 'email', 'password', 
            'age', 'bio', 'weight', 'height', 'goal', 'avatar'
        ]
        extra_kwargs = {
            'password': {'write_only': True},
            'avatar': {'required': False},
            'bio': {'required': False},
            'weight': {'required': False},
            'height': {'required': False},
            'goal': {'required': False},
        }

    def validate_email(self, value):
        # Validación personalizada para el email
        if "@" not in value:
            raise serializers.ValidationError("Debe proporcionar un email válido.")
        
        if CustomUser.objects.filter(email=value).exists():
            raise serializers.ValidationError("Este email ya está en uso.")
        
        return value

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = CustomUser(**validated_data)
        
        if password is not None:
            user.set_password(password)
        user.save()
        
        return user
