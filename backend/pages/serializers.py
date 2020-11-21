from rest_framework import serializers
from .models import Nongsaro, Sickdata, Pestidata, Nongsaro_sickdatas

class Nongsaro_sickdataSerializer(serializers.ModelSerializer):
    class Meta:
        model = Nongsaro_sickdatas
        fields = ('sick_data','dumy_data')

class NongsaroSerializer(serializers.ModelSerializer):
    sick_datas = Nongsaro_sickdataSerializer(read_only=True, many=True)
    class Meta:
        model = Nongsaro
        fields = ('crop_kind','crop_state','sick_kind','crop_name','sick_name','sick_datas')

class PestidataSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pestidata
        fields = ('pesti_name','pesti_name2','dis_name','pestiuse', 'pesti_img', 'toxic_name', 'dilutunit', 'usesuit_time', 'use_num')

class SickdataSerializer(serializers.ModelSerializer):
    pesti_datas = PestidataSerializer(read_only=True, many=True)
    class Meta:
        model = Sickdata
        fields = ('crop_name','sick_kind','sick_name','sick_img','prevent_method','pesti_datas')

class SicklistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sickdata
        fields = ('crop_name','sick_kind','sick_name','sick_img','prevent_method',)

