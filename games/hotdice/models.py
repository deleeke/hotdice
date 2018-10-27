from django.db import models
import random


class Game(models.Model):
    num_players = models.IntegerField(default=1)
    num_dice = models.IntegerField(default=6)
    max_pips = models.IntegerField(default=6)


class Player(models.Model):
    player_name = models.CharField(max_length=50)
    score = models.IntegerField(default=0)
    game = models.ForeignKey(Game, on_delete=models.CASCADE)
