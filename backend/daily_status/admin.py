from django.contrib import admin
from .models import DailyStatus

@admin.register(DailyStatus)
class DailyStatusAdmin(admin.ModelAdmin):
    list_display = ('user', 'date', 'energy_level', 'mood', 'has_pain', 'is_tired')
    list_filter = ('date', 'energy_level', 'mood', 'has_pain', 'is_tired')
    search_fields = ('user__username', 'notes')
