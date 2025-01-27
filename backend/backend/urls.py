# backend/urls.py
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    # En lugar de path('api/', ...), hacemos:
    path('api/users/', include('users.urls')),
    path('api/daily_status/', include('daily_status.urls')),
]
