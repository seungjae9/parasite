class Pest {
  String cropName;
  String sickKind;
  String sickName;
  String sickImg;
  String preventMethod;
  List<PestiDatas> pestiDatas;

  Pest(
      {this.cropName,
        this.sickKind,
        this.sickName,
        this.sickImg,
        this.preventMethod,
        this.pestiDatas});

  Pest.fromJson(Map<String, dynamic> json) {
    cropName = json['crop_name'];
    sickKind = json['sick_kind'];
    sickName = json['sick_name'];
    sickImg = json['sick_img'];
    preventMethod = json['prevent_method'];
    if (json['pesti_datas'] != null) {
      pestiDatas = new List<PestiDatas>();
      json['pesti_datas'].forEach((v) {
        pestiDatas.add(new PestiDatas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crop_name'] = this.cropName;
    data['sick_kind'] = this.sickKind;
    data['sick_name'] = this.sickName;
    data['sick_img'] = this.sickImg;
    data['prevent_method'] = this.preventMethod;
    if (this.pestiDatas != null) {
      data['pesti_datas'] = this.pestiDatas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PestiDatas {
  String pestiName;
  String disName;
  String pestiuse;
  String pestiImg;
  String toxicName;
  String dilutunit;
  String usesuitTime;
  String useNum;

  PestiDatas(
      {this.pestiName,
        this.disName,
        this.pestiuse,
        this.pestiImg,
        this.toxicName,
        this.dilutunit,
        this.usesuitTime,
        this.useNum});

  PestiDatas.fromJson(Map<String, dynamic> json) {
    pestiName = json['pesti_name'];
    disName = json['dis_name'];
    pestiuse = json['pestiuse'];
    pestiImg = json['pesti_img'];
    toxicName = json['toxic_name'];
    dilutunit = json['dilutunit'];
    usesuitTime = json['usesuit_time'];
    useNum = json['use_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pesti_name'] = this.pestiName;
    data['dis_name'] = this.disName;
    data['pestiuse'] = this.pestiuse;
    data['pesti_img'] = this.pestiImg;
    data['toxic_name'] = this.toxicName;
    data['dilutunit'] = this.dilutunit;
    data['usesuit_time'] = this.usesuitTime;
    data['use_num'] = this.useNum;
    return data;
  }
}