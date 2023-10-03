; 0 = Add, 1 = Edit
isVaccineInEditMode := false
equipWindowExist := false

currentEquip := NULL
currentEquipDose := NULL
currentVac := NULL
currentVacDose:= NULL

; Equipment Name
az_fn := "COVID-19 AstraZeneca"
sv_fn := "CORONAVAC"
pf_fn := "COVID-19 Pfizer"
sp_fn := "COVID-19 Sinopharm"
md_fn := "COVID-19 Moderna"
pfc_fn := "COVID-19 Pfizer เด็ก 5ปี ถึง<12ปี"
; Pfizer Red Newly Added
pfr_fn := "COVID-19 Pfizer เด็ก 0ปี ถึง<4ปี"
cvx_fn := "COVID-19 COVOVAX"

az_id := 1
sv_id := 2
pf_id := 3
sp_id := 4
md_id := 5
cvx_id := 6

az := "Astrazeneca"
sv := "Sinovac"
pf := "Pfizer"
pfc := "Pfizer (เด็กอายุ 5-11 ปี)"
; Pfizer Red Newly Added
pfr := "Pfizer (เด็กอายุ 0-4 ปี)"
sp := "Sinopharm"
md := "Moderna"
cvx := "Covovax"

vac_names := ["Astrazeneca", "Sinovac", "Pfizer", "Sinopharm", "Moderna", "Covovax"]

vaccine_preset := {"vac_id": NULL ,"vac_name": NULL, "dose_no": NULL, "lot_no": NULL, "exp_date": NULL, "serial_no": NULL}

f3key_timeout_msg := ["กดปุ่มตัวเลขไม่ทันในช่วงเวลาที่กำหนดไว้"]
wrong_dose_msg := ["ครั้งที่ฉีดไม่ตรงกับที่คีย์ในเวชภัณฑ์","แค่ฉีดโดสไหนยังกรอกไม่ถูก คงนานๆเหมือนถูกหวยซักครั้ง", "ครั้งที่ฉีดไม่ถูก กลับไปดูใหม่"]
wrong_sn_msg := ["Serial ไม่ถูกต้อง",  "Hello มองซิเออร์/มาดัม ซีเรียล Number ไม่ถืกนะนาย/เธอจ๋า"]
wrong_vac_msg := ["วัคซีนตรงกันหรือเปล่า ?", "วัคซีนไม่ตรงกับที่คีย์ใน F3 จกตา"]