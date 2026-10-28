import requests

url = "https://esllab.b-cdn.net/audio/mp3/reading.mp3"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "Referer": "https://www.esl-lab.com/",
}
response = requests.get(url, headers=headers)
if response.status_code == 200:
  with open("party.mp3", "wb") as f:
    f.write(response.content)
  print("تم التحميل بنجاح!")
else:
  print(f"Error: {response.status_code}")