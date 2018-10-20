from django.contrib import admin

from .models import SixSidedDie, Roll, HotDiceHand

admin.site.register(SixSidedDie)
admin.site.register(Roll)
admin.site.register(HotDiceHand)
