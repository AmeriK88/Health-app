from rest_framework import serializers
from .models import DailyStatus

class DailyStatusSerializer(serializers.ModelSerializer):
    recommendation = serializers.SerializerMethodField()

    class Meta:
        model = DailyStatus
        fields = ['id', 'date', 'energy_level', 'has_pain', 'is_tired', 'mood', 'notes', 'recommendation']

    def get_recommendation(self, obj):
        return obj.recommend_exercises()
