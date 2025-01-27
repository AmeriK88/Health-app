from django.urls import path
from .views import DailyStatusView

urlpatterns = [
    path('status/', DailyStatusView.as_view(), name='daily_status'),
]
