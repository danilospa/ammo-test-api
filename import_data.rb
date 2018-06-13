require 'json'
require 'dotenv/load'

ENV['RACK_ENV'] = 'development' unless ENV.include?('RACK_ENV')

require './lib/services/cache'
require './lib/services/search'

indexed_fields = %w[id name]
products = [
  {
    id: 1,
    name: 'Cama grande',
    old_price: 100.00,
    current_price: 55.55,
    images: [
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
      'https://schumann.vteximg.com.br/arquivos/ids/230787-1000-1000/10015830-cama-box-king-cristalflex-passione-193x203x68-cm-molas-pocket-001-principal.jpg?v=636456701110030000',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg'
    ],
    type: 'Classic',
    extra_information: 'Solteiro extra',
  },
  {
    id: 2,
    name: 'Cama pequena',
    old_price: 100.00,
    current_price: 55.55,
    images: [
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://schumann.vteximg.com.br/arquivos/ids/230787-1000-1000/10015830-cama-box-king-cristalflex-passione-193x203x68-cm-molas-pocket-001-principal.jpg?v=636456701110030000',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg'
    ],
    type: 'Classic II',
    extra_information: 'Solteiro extra',
  },
  {
    id: 3,
    name: 'Toalha lisa',
    old_price: 50.00,
    current_price: 10.55,
    images: [
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://schumann.vteximg.com.br/arquivos/ids/230787-1000-1000/10015830-cama-box-king-cristalflex-passione-193x203x68-cm-molas-pocket-001-principal.jpg?v=636456701110030000',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg'
    ],
    type: 'Classic I',
    extra_information: 'Solteiro extra',
  },
  {
    id: 4,
    name: 'Toalha escura',
    old_price: 20.00,
    current_price: 10.00,
    images: [
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://schumann.vteximg.com.br/arquivos/ids/230787-1000-1000/10015830-cama-box-king-cristalflex-passione-193x203x68-cm-molas-pocket-001-principal.jpg?v=636456701110030000',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 5,
    name: 'Toalha azul',
    old_price: 15.00,
    current_price: 10.00,
    images: [
      'https://schumann.vteximg.com.br/arquivos/ids/230787-1000-1000/10015830-cama-box-king-cristalflex-passione-193x203x68-cm-molas-pocket-001-principal.jpg?v=636456701110030000',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 6,
    name: 'Toalha azul marinho',
    old_price: 15.00,
    current_price: 10.00,
    images: [
      'http://i2marabraz-a.akamaihd.net/1800x1800/59/00007880767__1_B_ND.jpg',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 7,
    name: 'Toalha manchada',
    old_price: 12.00,
    current_price: 10.00,
    images: [
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'http://i2marabraz-a.akamaihd.net/1800x1800/59/00007880767__1_B_ND.jpg',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 8,
    name: 'Pano manchada',
    old_price: 90.00,
    current_price: 10.00,
    images: [
      'http://i2marabraz-a.akamaihd.net/1800x1800/59/00007880767__1_B_ND.jpg',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 9,
    name: 'Pano escuro',
    old_price: 90.00,
    current_price: 10.00,
    images: [
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'http://i2marabraz-a.akamaihd.net/1800x1800/59/00007880767__1_B_ND.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 10,
    name: 'Cama queen',
    old_price: 90.00,
    current_price: 10.00,
    images: [
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
      'http://i2marabraz-a.akamaihd.net/1800x1800/59/00007880767__1_B_ND.jpg',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 11,
    name: 'Cama king',
    old_price: 99.00,
    current_price: 10.00,
    images: [
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
      'https://novomundo.vteximg.com.br/arquivos/ids/183069-500-500/cama-solteiro-100-mdf-bom-pastor-plus-branco-preto-32089-0png.jpg?v=635655101598370000',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
  {
    id: 12,
    name: 'Cama small',
    old_price: 99.00,
    current_price: 10.00,
    images: [
      'https://assets.lojaskd.com.br/144600/144671/144671_18_zoom_180.jpg',
      'https://novomundo.vteximg.com.br/arquivos/ids/183069-500-500/cama-solteiro-100-mdf-bom-pastor-plus-branco-preto-32089-0png.jpg?v=635655101598370000',
      'https://cdn-fotos-s3.meumoveldemadeira.com.br/fotos-moveis/cama-de-casal-setorize-cru-fosco-e-nozes-com-tabaco-mini.jpg',
      'https://toqueacampainha.vteximg.com.br/arquivos/ids/1326048-530-530/107265_1.jpg?v=636326109371070000',
    ],
    type: 'Classic VI',
    extra_information: 'Solteiro extra',
  },
]

products.each do |product|
  indexed_product = product.select { |k, _| indexed_fields.include?(k.to_s) }
  Services::Search.new.index('product', product[:id], indexed_product)
  Services::Cache.new.set(product[:id], product.to_json)
end
