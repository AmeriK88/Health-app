from django.contrib import admin
from .models import DailyStatus

@admin.register(DailyStatus)
class DailyStatusAdmin(admin.ModelAdmin):
    list_display = ('user', 'date', 'energy_level', 'pain', 'tiredness', 'mood')
    list_filter = ('date', 'energy_level', 'mood')
