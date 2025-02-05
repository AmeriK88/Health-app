from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser

@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    model = CustomUser

    list_display = ('username', 'first_name', 'last_name', 'email', 'age', 'weight', 'height', 'goal', 'is_staff')
    search_fields = ('username', 'email', 'first_name', 'last_name')
    ordering = ('username',)

    # Asegúrate de NO duplicar los campos first_name y last_name
    fieldsets = UserAdmin.fieldsets + (
        ('Información Adicional', {
            'fields': ('age', 'bio', 'weight', 'height', 'goal', 'avatar'),
        }),
    )

    add_fieldsets = UserAdmin.add_fieldsets + (
        ('Información Adicional', {
            'fields': ('age', 'bio', 'weight', 'height', 'goal', 'avatar'),
        }),
    )


admin.site.unregister(CustomUser)
admin.site.register(CustomUser, CustomUserAdmin)