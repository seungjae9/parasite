from django.db import models

# Create your models here.
class Nongsaro_sickdatas(models.Model):
    sick_data = models.CharField(max_length=300)
    dumy_data = models.CharField(max_length=100)

class Nongsaro(models.Model):
    crop_kind = models.CharField(max_length=100)
    crop_state = models.CharField(max_length=100)
    sick_kind = models.CharField(max_length=100)
    crop_name = models.CharField(max_length=100)
    sick_name = models.CharField(max_length=100)
    sick_datas = models.ManyToManyField(Nongsaro_sickdatas, related_name='nongsaro_sickdata')

class Pestidata(models.Model):
    pesti_name = models.CharField(max_length=100)
    pesti_name2 = models.CharField(max_length=100)
    dis_name = models.CharField(max_length=100)
    pestiuse = models.CharField(max_length=100)
    pesti_img = models.CharField(max_length=100)
    toxic_name = models.CharField(max_length=100)
    dilutunit = models.CharField(max_length=100)
    usesuit_time = models.CharField(max_length=100)
    use_num = models.CharField(max_length=100)

class Sickdata(models.Model):
    crop_name = models.CharField(max_length=100)
    sick_kind = models.CharField(max_length=100)
    sick_name = models.CharField(max_length=100)
    sick_img = models.CharField(max_length=100)
    prevent_method = models.TextField()
    sick_symptoms = models.TextField()
    sick_condition = models.TextField()
    pesti_datas = models.ManyToManyField(Pestidata, related_name='pesti_data')


