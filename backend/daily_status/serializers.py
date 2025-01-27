from rest_framework import serializers
from .models import DailyStatus

class DailyStatusSerializer(serializers.ModelSerializer):
    recommendation = serializers.SerializerMethodField()  # Campo para recomendaciones

    class Meta:
        model = DailyStatus
        fields = ['id', 'date', 'energy_level', 'pain', 'tiredness', 'mood', 'notes', 'recommendation']

    def get_recommendation(self, obj):
        return obj.recommend_exercises()
