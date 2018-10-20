from django.http import HttpResponse

from .models import HotDiceHand


def index(request):
    hands = HotDiceHand.objects.order_by("-score")
    return HttpResponse(hands)
