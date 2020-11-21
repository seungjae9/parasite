from django.contrib import admin
from .models import Nongsaro, Sickdata, Pestidata, Nongsaro_sickdatas

# Register your models here.
admin.site.register(Nongsaro)
admin.site.register(Sickdata)
admin.site.register(Pestidata)
admin.site.register(Nongsaro_sickdatas)