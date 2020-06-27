import requests
import pandas as pd
from datetime import datetime

resposta = requests.get("https://api.cotacoes.uol.com/currency/interday/list/years/?format=JSON&fields=bidvalue,askvalue,maxbid,minbid,variationbid,variationpercentbid,openbidvalue,date&currency=1&")

dollar_json = resposta.json()

serie = []
for i, doc in enumerate(dollar_json["docs"]):
  dolar = {
      "askvalue": doc.get("askvalue", ""),
      "date": datetime.strptime(doc.get("date", ""), "%Y%m%d000000")
  }
  serie.append(dolar)

df_dolar = pd.DataFrame(serie)

df_dolar = df_dolar.sort_values("date", ascending = True)

df_dolar.to_csv("dolar_real.csv", index = False)
