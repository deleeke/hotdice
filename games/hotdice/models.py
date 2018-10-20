from random import randint

from django.conf import settings
from django.db import models


class SixSidedDie(models.Model):
    roll = models.ForeignKey("Roll", models.CASCADE)
    max_pips = models.IntegerField(default=6)
    min_pips = models.IntegerField(default=1)
    current_pips = models.IntegerField(default=1)
    is_chosen = models.BooleanField(default=True)

    def roll_die(self):
        self.current_pips = randint(1, 6)


class Roll(models.Model):
    hand = models.ForeignKey("HotDiceHand", models.CASCADE)
    score = models.IntegerField(default=0)


class HotDiceHand(models.Model):
    score = models.IntegerField(default=0)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
