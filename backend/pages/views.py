from django.shortcuts import render, HttpResponse, get_object_or_404
from .models import Nongsaro, Sickdata, Pestidata, Nongsaro_sickdatas
import csv
import requests
import urllib.parse as parser
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
import django.http.response
from .serializers import NongsaroSerializer, SickdataSerializer, Nongsaro_sickdataSerializer, SicklistSerializer, PestidataSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view
from lxml.html import parse
from io import StringIO

# Create your views here.


def index(request):

    return render(request, 'index.html')

@api_view(['GET'])
def datas(request):
    nongsaro = Nongsaro.objects.all()
    serializer = NongsaroSerializer(nongsaro, many=True)
    return Response(serializer.data)

def datas_detail_list(request):
    datas = Nongsaro.objects.all()
    context = {
        'datas':datas
    }
    return render(request, 'nongsaro.html', context)

@api_view(['GET'])
def datas_detail(request, id):
    print('datas_detail@@@@@@@@@@@@@@')
    nongsaro = get_object_or_404(Nongsaro, id=id)
    serializer = NongsaroSerializer(nongsaro)
    return Response(serializer.data)


def datas2(request):
    datas = Sickdata.objects.all()
    context = {
        'datas':datas
    }
    return render(request, 'datas.html', context)

@api_view(['GET'])
def datas2_detail(request, id):
    print('datas2_detail@@@@@@@@@@@@@@')
    sickdata = get_object_or_404(Sickdata, id=id)
    serializer = SickdataSerializer(sickdata)
    return Response(serializer.data)

@api_view(['GET'])
def datas3(request):
    print('datas3@@@@@@@@@@@@@@')
    sickdata = Sickdata.objects.all()
    serializer = SicklistSerializer(sickdata, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def datas4(request):
    pestidata = Pestidata.objects.all()
    serializer = PestidataSerializer(pestidata, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def sicksearch(request, crop, sick):
    sickdata = get_object_or_404(Sickdata, sick_name=sick, crop_name=crop)
    serializer = SickdataSerializer(sickdata)
    return Response(serializer.data)

@api_view(['GET'])
def searchtest(request):
    sickdata = get_object_or_404(Sickdata, sick_name='탄저병', crop_name='사과')
    serializer = SickdataSerializer(sickdata)
    return Response(serializer.data)

# 검색
@api_view(['POST'])
def search(request):
    print('search@@@@@')
    sick_apiurl = 'http://ncpms.rda.go.kr/npmsAPI/service'
    sick_apikey = '2020bc251a4e18ca0830201bff4ebe390037'    
    print(request.POST.get('search_crop'))
    if request.method == 'POST':
        search_crop = request.POST.get('search_crop')

        open_url = f'{sick_apiurl}?apiKey={sick_apikey}&serviceCode=SVC01&serviceType=AA001&cropName={search_crop}&displayCount=50&startPoint=1'
        # print(open_url)
        res = requests.get(open_url)
        soup = BeautifulSoup(res.content, 'html.parser')
        datalist = soup.find_all('item')
        
        a = []
        for item in datalist:
            print(item)
            b = item.find('sicknamekor').get_text()
            a.append(b)

        context = {
            'a':a
        }

    return Response(a)

def map(request):
    return render(request, 'map.html')

def map2(request):
    queryString = request.META["QUERY_STRING"]
    openapi_url = "http://ncpms.rda.go.kr/npmsAPI/service?"+queryString
    post = requests.get(openapi_url).text
    asdf = parser.unquote_plus(post).replace('&nbsp;', ' ')
    return HttpResponse(post, content_type='text/xml')



# 월간 병해충 정보 입력
def newdata():
    print('newdata@@@@')
    f = open('month_4.csv', 'r', encoding='CP949')
    rdr = csv.reader(f)
    for line in rdr:
        crop_kind = line[0]
        crop_state = line[1]
        sick_kind = line[2]
        crop_name = line[3]
        sick_name = line[4]
        sick_data = [line[5]]
        idx = 6
        print(len(line))
        while True:
            if idx < len(line) and line[idx]:
                print(line[idx])
                sick_data.append(line[idx])
                idx += 1
            else:
                break
        nongsaro = Nongsaro.objects.create(  crop_kind = line[0],
                                            crop_state = crop_state,
                                            sick_kind = sick_kind,
                                            crop_name = crop_name,
                                            sick_name = sick_name,
                                        )
        for jj in sick_data:
            print(jj)
            nongsaro_sickdatas = Nongsaro_sickdatas.objects.create(
                sick_data = jj,
                dumy_data = 'gg'
            )
            nongsaro.sick_datas.add(nongsaro_sickdatas)
    f.close()

    # return render(request, 'index.html')


# 전체 DB용 데이터
def newdata2():
    sick_apiurl = 'http://ncpms.rda.go.kr/npmsAPI/service'
    sick_apikey = '2020bc251a4e18ca0830201bff4ebe390037'
    # 복준자, 피망, 신선초, 양상추, 밀, 메밀, 들깨, 땅콩, 유채, 강활, 참취, 곤달비, 인삼, 논콩  <= 내용안나와서 삭제
    # 석류 <= 64작물에 없지만 있길래 추가
    # crop_list = ['사과','배','포도','감귤','참다래','매실','유자','감','복숭아',
    #             '수박','참외','딸기','오이','토마토','메론','호박','가지','고추',
    #             '배추','양배추','시금치','쑥갓','샐러리','상추','케일','부추',
    #             '당근','우엉','무','생강','도라지','마',
    #             '양파','마늘',
    #             '보리','옥수수','수수','조','벼',
    #             '콩','팥','감자','고구마','참깨',
    #             '황기','오미자','구기자','당귀','산수유','맥문동',
    #             '곰취',
    #             '석류']

    crop_list = ['사과','고추']
    for crop_name in crop_list:
        print(crop_name)
        # 1. 작물명과 병명 가져와서(ex.작물명:양파, 병명:노균병) sickKey를 추출
        open_url = f'{sick_apiurl}?apiKey={sick_apikey}&serviceCode=SVC01&serviceType=AA001&cropName={crop_name}&displayCount=50&startPoint=1'
        # print(open_url)
        res = requests.get(open_url)
        soup = BeautifulSoup(res.content, 'html.parser')
        data_list = soup.find_all('item')
        
        for data in data_list:
            data_name = data.find('cropname').get_text()
            if crop_name == data_name:
                sick_name = data.find('sicknamekor').get_text()
                sick_img = data.find('oriimg').get_text()
                # print(data.find('thumbimg').get_text())

                # 2. sickKey 기반으로 해당 작물의 병 상세정보 조회 그러면 이미지와 기타 정보를 가져올 수 있음
                sick_key = data.find('sickkey').get_text()
                detail_url = f'{sick_apiurl}?apiKey={sick_apikey}&serviceCode=SVC05&serviceType=AA001&sickKey={sick_key}'
                print(detail_url)
                res = requests.get(detail_url)
                soup = BeautifulSoup(res.content, 'html.parser')
                prevent_method = soup.find('preventionmethod').get_text()
  
                sick_symptoms = soup.find('symptoms').get_text()
                sick_condition = soup.find('developmentcondition').get_text()

                sickdata = Sickdata.objects.create(
                    crop_name = crop_name,
                    sick_kind = '병',
                    sick_name = sick_name,
                    sick_img = sick_img,
                    prevent_method = prevent_method,
                    sick_symptoms = sick_symptoms,
                    sick_condition = sick_condition,
                )

                print(crop_name,sick_name)
                # 농약 정보 불러오기
                pesti_apiurl = 'http://pis.rda.go.kr/openApi/service.do'
                pesti_apikey = '2020d580948c651abf71fcbca0f58d7cbc10'
                pesti_url = f'{pesti_apiurl}?apiKey={pesti_apikey}&serviceCode=SVC01&cropName={crop_name}&cropCheck={crop_name}&displayCount=50&diseaseWeedName={sick_name}'
                print(pesti_url)
                res = requests.get(pesti_url)
                soup = BeautifulSoup(res.content, 'html.parser')
                data = soup.find_all('item')
                pesti_5 = []
                for item in data:
                    pesti_name = item.find('pestikorname').get_text()
                    if pesti_name not in pesti_5 and len(pesti_5) <= 4:
                        pesti_5.append(pesti_name)

                        pesti_code = item.find('pesticode').get_text()
                        dis_seq = item.find('diseaseuseseq').get_text()
                        
                        # 4. pesti_code와 disea_seq를 기반으로 농약 상세조회
                        open_url = f'{pesti_apiurl}?apiKey={pesti_apikey}&serviceCode=SVC02&pestiCode={pesti_code}&diseaseUseSeq={dis_seq}'
                        # print(open_url)
                        res = requests.get(open_url)
                        soup = BeautifulSoup(res.content, 'html.parser')
                        data = soup.find('service')
                        pesti_name = data.find('pestikorname').get_text()
                        pesti_name2 = f'{pesti_name}({crop_name}):{sick_name}'

                        # print(data.find('usename').get_text())
                        # print(data.find('compname').get_text())
                        # print(data.find('pestibrandname').get_text())
                        # print(data.find('pestiengname').get_text())
                        # print(data.find('regcpntqnty').get_text())
                        # print(data.find('toxicgubun').get_text())
                        # 독성
                        toxic_name = data.find('toxicname').get_text()
                        # print(data.find('fishtoxicgubun').get_text())
                        # print(data.find('cropname').get_text())
                        # print(data.find('diseaseweedname').get_text())
                        # 사용적기
                        pesti_use = data.find('pestiuse').get_text()
                        # 희석배수
                        dilutunit = data.find('dilutunit').get_text()
                        if dilutunit[-1] == '-':
                            dilutunit = dilutunit[0:len(dilutunit)-2]
                        # 안전사용기준(수확~일전)
                        usesuit_time = data.find('usesuittime').get_text()
                        # 안전사용기준(~회 이내)
                        use_num = data.find('usenum').get_text()

                        #농약 구글 이미지 크롤링
                        url = f'https://www.google.com/search?q={pesti_name}&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiJmvugou_pAhULyYsBHaWYAmIQ_AUoAXoECAwQAw&biw=2560&bih=1297'
                        print(url)
                        # html 소스 가져오기
                        text = requests.get(url).text

                        # html 문서로 파싱
                        text_source = StringIO(text)
                        parsed = parse(text_source)

                        # root node 
                        doc = parsed.getroot()
                        print(doc)
                        # img 경로는 img 태그안에 src에 있음(20개만 크롤링 됨.. 이유 찾아봐야 됨)
                        imgs = doc.findall('.//img')
                        pesti_img = imgs[1].get('src')

                        pestidata = Pestidata.objects.create(
                            pesti_name = pesti_name,
                            pesti_name2 = pesti_name2,
                            dis_name = sick_name,
                            pestiuse = pesti_use,
                            pesti_img = pesti_img,
                            toxic_name = toxic_name,
                            dilutunit = dilutunit,
                            usesuit_time = usesuit_time,
                            use_num = use_num,
                        )
                        sickdata.pesti_datas.add(pestidata)
                print(pesti_5)            


        print('해충정보@@@@@@@')
        open_url = f'{sick_apiurl}?apiKey={sick_apikey}&serviceCode=SVC03&serviceType=AA001&cropName={crop_name}&displayCount=50&startPoint=1'
        # print(open_url)
        res = requests.get(open_url)
        soup = BeautifulSoup(res.content, 'html.parser')
        data_list = soup.find_all('item')
        for data in data_list:
            data_name = data.find('cropname').get_text()
            if crop_name == data_name:
                # 해충 디테일 정보 가져오기
                bug_name = data.find('insectkorname').get_text()
                insec_key = data.find('insectkey').get_text()
                sick_img = data.find('oriimg').get_text()
                detail_url = f'{sick_apiurl}?apiKey={sick_apikey}&serviceCode=SVC07&serviceType=AA001&insectKey={insec_key}'
                print(detail_url)
                res = requests.get(detail_url)
                soup = BeautifulSoup(res.content, 'html.parser')

                prevent_method = soup.find('preventmethod').get_text()
                sick_symptoms = soup.find('damageinfo').get_text()
                sick_condition = soup.find('ecologyinfo').get_text()  
                sickdata = Sickdata.objects.create(
                    crop_name = crop_name,
                    sick_kind = '해충',
                    sick_name = bug_name,
                    sick_img = sick_img,
                    prevent_method = prevent_method,
                    sick_symptoms = sick_symptoms,
                    sick_condition = sick_condition,
                )


                print(crop_name,bug_name)
                # 농약 정보 불러오기
                pesti_apiurl = 'http://pis.rda.go.kr/openApi/service.do'
                pesti_apikey = '2020d580948c651abf71fcbca0f58d7cbc10'
                pesti_url = f'{pesti_apiurl}?apiKey={pesti_apikey}&serviceCode=SVC01&cropName={crop_name}&cropCheck={crop_name}&displayCount=50&diseaseWeedName={bug_name}'
                print(pesti_url)
                res = requests.get(pesti_url)
                soup = BeautifulSoup(res.content, 'html.parser')
                data = soup.find_all('item')
                pesti_5 = []
                for item in data:
                    pesti_name = item.find('pestikorname').get_text()
                    if pesti_name not in pesti_5 and len(pesti_5) <= 4:
                        pesti_5.append(pesti_name)

                        pesti_code = item.find('pesticode').get_text()
                        dis_seq = item.find('diseaseuseseq').get_text()
                    
                        # 4. pesti_code와 disea_seq를 기반으로 농약 상세조회
                        open_url = f'{pesti_apiurl}?apiKey={pesti_apikey}&serviceCode=SVC02&pestiCode={pesti_code}&diseaseUseSeq={dis_seq}'
                        # print(open_url)
                        res = requests.get(open_url)
                        soup = BeautifulSoup(res.content, 'html.parser')
                        data = soup.find('service')
                        pesti_name = data.find('pestikorname').get_text()
                        pesti_name2 = f'{pesti_name}({crop_name}):{sick_name}'
                        # print(data.find('usename').get_text())
                        # print(data.find('compname').get_text())
                        # print(data.find('pestibrandname').get_text())
                        # print(data.find('pestiengname').get_text())
                        # print(data.find('regcpntqnty').get_text())
                        # print(data.find('toxicgubun').get_text())
                        # 독성
                        toxic_name = data.find('toxicname').get_text()
                        # print(data.find('fishtoxicgubun').get_text())
                        # print(data.find('cropname').get_text())
                        # print(data.find('diseaseweedname').get_text())
                        # 사용적기
                        pesti_use = data.find('pestiuse').get_text()
                        # 희석배수
                        dilutunit = data.find('dilutunit').get_text()
                        if dilutunit[-1] == '-':
                            dilutunit = dilutunit[0:len(dilutunit)-2]
                        # 안전사용기준(수확~일전)
                        usesuit_time = data.find('usesuittime').get_text()
                        # 안전사용기준(~회 이내)
                        use_num = data.find('usenum').get_text()

                        # 농약 구글이미지 크롤링
                        url = f'https://www.google.com/search?q={pesti_name}&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiJmvugou_pAhULyYsBHaWYAmIQ_AUoAXoECAwQAw&biw=2560&bih=1297'
                        # html 소스 가져오기
                        text = requests.get(url).text

                        # html 문서로 파싱
                        text_source = StringIO(text)
                        parsed = parse(text_source)

                        # root node 
                        doc = parsed.getroot()
                        # img 경로는 img 태그안에 src에 있음(20개만 크롤링 됨.. 이유 찾아봐야 됨)
                        imgs = doc.findall('.//img')
                        pesti_img = imgs[1].get('src')

                        pestidata = Pestidata.objects.create(
                            pesti_name = pesti_name,
                            pesti_name2 = pesti_name2,
                            dis_name = sick_name,
                            pestiuse = pesti_use,
                            pesti_img = pesti_img,
                            toxic_name = toxic_name,
                            dilutunit = dilutunit,
                            usesuit_time = usesuit_time,
                            use_num = use_num,
                        )
                        sickdata.pesti_datas.add(pestidata)

                print(pesti_5)     
    
    # return render(request, 'index.html')

# newdata()
# newdata2()
