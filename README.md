# vagas-dod

Bem vindo(a) a jornada. Aqui você vai encontrar todos os detalhes para o teste!

#Flutter
Para o teste de Dev Flutter, você deve completar as seguintes tarefas:

Seu app deve ser capaz de:
1. Abrir a câmera e tirar uma foto
2. Converter esta foto para base64
3. Enviar este base64 para uma API 
4. Receber a resposta da API e exibir no APP

###### Dados de apoio:
Enviar uma chamada do tipo POST para a URL:
`https://tv.dodvision.com/test-app/`

Conteúdo esperado:
``{
    "image":"coloque_o_base64_aqui"
}
``

###### IMPORTANTE:
deve ser um objeto do tipo JSON válido, pois o servidor espera estes elementos corretamente.

###### Exemplo de resposta:

``{
    "emissora": {
        "pessoas": [
            "sbt-Ratinho"
        ],
        "objects": [
            "cup",
            "tie"
        ],
        "final_image": "media/1ZTG9C.JPG"
    }
}
``
###### IMPORTANTE:
Você deve interpretar esta resposta de retorno e exibir a tela a imagem contida no elemento "final_image"


Bom, se você chegou até aqui. Parabéns, agora é só gerar o app mandar para nós junto com o código para validarmos, ok?

Boa sorte!!!!
