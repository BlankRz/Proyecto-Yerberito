:- use_module(library(pce)).
:- pce_global(@name_prompter, make_name_prompter).

%Creacion y estructura de nuestro programa
mostrar(V, D, M) :-
    new(I, image(V)),
    new(B, bitmap(I)),
    new(F2, figure),
    send(F2, display, B),
    new(D1, device),
    send(D1, display, F2),
    send(D, display, D1),
    send(D1, below(M)).

make_name_prompter(P) :-
    new(P, dialog),
    send(P, kind, transient),
    send(P, append, label(prompt)),
    send(P, append,
        new(TI, text_item(name, '', message(P?ok_member, execute)))),
    send(P, append, button(ok, message(P, return, TI?selection))),
    send(P, append, button(cancel, message(P, return, @nil))).

%Funciones para hacer funcionar el menú
ask_name(Prompt, Label, Name) :-
    send(@name_prompter?prompt_member, selection, Prompt),
    send(@name_prompter?name_member, label, Label),
    send(@name_prompter?name_member, clear),
    get(@name_prompter, confirm_centered, RawName),
    send(@name_prompter, show, @off),
    RawName \== @nil,
    Name = RawName.

ask_name :-
    ask_name('Plantas Medicinales', 'Planta', Planta),
    pp(Planta).

ask_name1 :-
    ask_name('Efectos:', 'Buscar', Efecto),
    pp1(Efecto).

ask_name2 :-
    ask_name('Cura: ', 'Planta:', Cura),
    pp2(Cura).

ask_name3 :-
    ask_name('Usos: ', 'Planta:', Uso),
    pp3(Uso).

ask_name4 :-
    ask_name('Plantas medicinales ','Enfermedad:', Enfermedad),
    pp4(Enfermedad).

ask_name5 :-
    ask_name('Medicamentos ','Planta:', Medicamento),
    pp5(Medicamento).



%Funcion principal y diseño de la página principal
start :-
    new(D, dialog('El Yerberito Compilado')),
    send(D, size, size(660, 400)),
    send(D, colour, colour(red)),
    send(D, append, new(Menu, menu_bar)),
    send(Menu, append, new(Iniciar, popup(iniciar))),
    send(Menu, append, new(Iniciar1, popup('Efectos: '))),
    send(Menu, append, new(Iniciar2, popup(botiquin))),
    send_list(Iniciar, append,
        [menu_item(iniciar, message(@prolog, ask_name))]),
    send_list(Iniciar,append,
         [menu_item(mostrar_lista_plantas,message(@prolog, mostrar_lista_plantas))]),
    send_list(Iniciar1, append,
        [menu_item(efectos, message(@prolog, ask_name1))]),
    send_list(Iniciar1, append,
        [menu_item(cura, message(@prolog, ask_name2))]),
    send_list(Iniciar1, append,
        [menu_item('Uso', message(@prolog, ask_name3))]),
    send_list(Iniciar2, append,
        [menu_item(botiquin, message(@prolog, botiquin))]),
    send_list(Iniciar2,append,
         [menu_item(enfermedad,message(@prolog, ask_name4))]),
    send_list(Iniciar2,append,
         [menu_item(medicamento,message(@prolog, ask_name5))]),
    send_list(Iniciar2,append,
         [menu_item(lista_enfermedad,message(@prolog, lista_enfermedad))]),
    send_list(Iniciar2,append,
         [menu_item(lista_medicamento,message(@prolog, lista_medicamento))]),
    mostrar('C:/Proyecto/plantas/yerberito.jpeg',D,Menu),
    send(D, display, text('Sistema Experto\nEl Yerberito Ilustrado\n\nElaborado por:\nMaria Guadalupe  Gonzalez Hernández\nBlanca Isabel Hernández Ruiz\nGermán Jiménez Torres', center, normal), point(320, 160)),
    send(D, open, point(0, 0)),
    consult('proyec.pl'),
    nl.
%Funcion para la lista de plantas
mostrar_lista_plantas :-
    new(D, dialog('Lista de Plantas Medicinales')),
    send(D, size, size(300, 500)),
    send(D, colour, colour(white)),

    new(LB, list_browser),
    send(LB, size, size(30, 30)),
    send(D, append, LB),

    findall(Nombre, nombre(Nombre, _), ListaPlantas),

    forall(member(Planta, ListaPlantas),
           send(LB, append, dict_item(Planta))),

    send(D, open, point(100, 100)),
    nl.

lista_enfermedad :-
    new(D, dialog('Lista de Enfermedades que pueden curarse con Plantas: ')),
    send(D, size, size(300, 500)),
    send(D, colour, colour(white)),
    new(LB, list_browser),
    send(LB, size, size(30, 30)),
    send(D, append, LB),
    findall(Enfermedad, enfermedad(Enfermedad, _), Lista_enfermedad),
    forall(member(Planta, Lista_enfermedad),
           send(LB, append, dict_item(Planta))),
    send(D, open, point(100, 100)),
    nl.
lista_medicamento :-
    new(D, dialog('Medicamentos que pueden hacerse con Plantas: ')),
    send(D, size, size(300, 500)),
    send(D, colour, colour(white)),
    findall(Medicamento, medicamento(_, Medicamento), Lista_medicamento),
    atomics_to_string(Lista_medicamento, '\n', StringLista),
    send(D, append, new(label('Medicamentos:', StringLista))),
    send(D, open, point(100, 100)),
    nl.
botiquin :-
    new(D, dialog('Botiquin en casa')),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text('Plantas que podrían servir en casa:', center, normal), point(320, 5)),
    send(D, display, text('Anis estrella, Menta arnica, Salvia, Tila, Eucalipto, \nYerbabuena, Manzanilla, Cola de caballo, Romero, Toronjil,\n Sanguinaria, Linaza, Hamamelis, Zarzaparrilla, Boldo, \nDiente de león, Azahar, Malva, Marrubio, Rosal ', center, normal), point(320, 60)),
    iman('Botiquin', Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.

% Relacion de cada elemento con su imagen correspondiente
iman('Abrojo', 'C:/Proyecto/plantas/abrojo.jpeg').
iman('Acacia', 'C:/Proyecto/plantas/acacia.jpg').
iman('Acanto', 'C:/Proyecto/plantas/acanto.jpg').
iman('Aceitilla', 'C:/Proyecto/plantas/aceitilla.jpg').
iman('Achicoria', 'C:/Proyecto/plantas/achicoria.jpeg').
iman('Aconito', 'C:/Proyecto/plantas/aconito.jpeg').
iman('Ahuehuete', 'C:/Proyecto/plantas/ahuehuete.jpg').
iman('Anis', 'C:/Proyecto/plantas/anis.jpeg').
iman('Berro', 'C:/Proyecto/plantas/berro.jpeg').
iman('Canela', 'C:/Proyecto/plantas/canela.jpeg').
iman('Cedron', 'C:/Proyecto/plantas/cedron.jpg').
iman('Cola de caballo', 'C:/Proyecto/plantas/cola_de_caballo.jpeg').
iman('Damiana', 'C:/Proyecto/plantas/damiana.jpeg').
iman('Diente de leon', 'C:/Proyecto/plantas/diente_de_leon.jpeg').
iman('Doradilla', 'C:/Proyecto/plantas/doradilla.jpeg').
iman('Genciana', 'C:/Proyecto/plantas/genciana.jpg').
iman('Grama', 'C:/Proyecto/plantas/grama.jpeg').
iman('Linaza', 'C:/Proyecto/plantas/linaza.jpeg').
iman('Manzanilla', 'C:/Proyecto/plantas/manzanilla.jpeg').
iman('Pinguica', 'C:/Proyecto/plantas/pinguica.jpeg').
iman('Romero', 'C:/Proyecto/plantas/romero.jpeg').
iman('Salvia', 'C:/Proyecto/plantas/salvia.jpeg').
iman('Sanguinaria', 'C:/Proyecto/plantas/sanguinaria.jpeg').
iman('Sensitiva', 'C:/Proyecto/plantas/sensitiva.jpeg').
iman('Simonillo', 'C:/Proyecto/plantas/simonillo.jpg').
iman('Tronadora', 'C:/Proyecto/plantas/tronadora.jpeg').
iman('Zarzaparrilla', 'C:/Proyecto/plantas/zarzaparrilla.jpeg').
iman('Malva', 'C:/Proyecto/plantas/Malva.jpeg').
iman('Perejil', 'C:/Proyecto/plantas/Perejil.jpeg').
iman('Limon', 'C:/Proyecto/plantas/Limon.jpeg').
iman('Sauco', 'C:/Proyecto/plantas/Sauco.jpeg').
iman('Arnica', 'C:/Proyecto/plantas/Arnica.jpeg').
iman('Llanten', 'C:/Proyecto/plantas/Llanten.jpeg').
iman('Fenogreco', 'C:/Proyecto/plantas/Fenogreco.jpeg').
iman('Zarzamora', 'C:/Proyecto/plantas/Zarzamora.jpeg').
iman('Tib', 'C:/Proyecto/plantas/Tib.jpeg').
iman('Valeriana', 'C:/Proyecto/plantas/Valeriana.jpeg').
iman('Yerbabuena', 'C:/Proyecto/plantas/Yerbabuena.jpeg').
iman('Quina roja', 'C:/Proyecto/plantas/Quina roja.jpeg').
iman('Encino rojo', 'C:/Proyecto/plantas/Encino rojo.jpeg').
iman('Pimiento', 'C:/Proyecto/plantas/Pimiento.jpeg').
iman('Hamamelis', 'C:/Proyecto/plantas/Hamamelis.jpeg').
iman('Toques', 'C:/Proyecto/plantas/Toques.jpeg').
iman('Ajenjo', 'C:/Proyecto/plantas/Ajenjo.jpeg').
iman('Germen de trigo', 'C:/Proyecto/plantas/Germen de trigo.jpeg').
iman('Eucalipto', 'C:/Proyecto/plantas/Eucalipto.jpeg').
iman('Cebada', 'C:/Proyecto/plantas/Cebada.jpeg').
iman('Tabachin', 'C:/Proyecto/plantas/Tabachin.jpeg').
iman('Borraja', 'C:/Proyecto/plantas/Borraja.jpeg').
iman('Cardo', 'C:/Proyecto/plantas/Cardo.jpeg').
iman('Chicalote', 'C:/Proyecto/plantas/Chicalote.jpeg').
iman('Alcanfor', 'C:/Proyecto/plantas/Alcanfor.jpeg').
iman('Marrubio', 'C:/Proyecto/plantas/Marrubio.jpeg').
iman('Oregano', 'C:/Proyecto/plantas/Oregano.jpeg').
iman('Lupulo', 'C:/Proyecto/plantas/Lupulo.jpeg').
iman('Cuasia', 'C:/Proyecto/plantas/Cuasia.jpeg').
iman('Uva', 'C:/Proyecto/plantas/Uva.jpeg').
iman('Cerezo', 'C:/Proyecto/plantas/Cerezo.jpeg').
iman('Rosal', 'C:/Proyecto/plantas/Rosal.jpeg').
iman('Ortiga', 'C:/Proyecto/plantas/Ortiga.jpeg').
iman('Espinosilla', 'C:/Proyecto/plantas/Espinosilla.jpeg').
iman('Retama', 'C:/Proyecto/plantas/Retama.jpeg').
iman('Ajo', 'C:/Proyecto/plantas/Ajo.jpeg').
iman('Cebolla', 'C:/Proyecto/plantas/Cebolla.jpeg').
iman('Hiedra', 'C:/Proyecto/plantas/Hiedra.jpeg').
iman('Siempreviva', 'C:/Proyecto/plantas/Siempreviva.jpeg').
iman('Mastuerzo', 'C:/Proyecto/plantas/Mastuerzo.jpeg').
iman('Higuera', 'C:/Proyecto/plantas/Higuera.jpeg').
iman('Menta', 'C:/Proyecto/plantas/Menta.jpeg').
iman('Hinojo', 'C:/Proyecto/plantas/Hinojo.jpeg').
iman('Boldo', 'C:/Proyecto/plantas/Boldo.jpeg').
iman('Matarique', 'C:/Proyecto/plantas/Matarique.jpeg').
iman('Alpachaca', 'C:/Proyecto/plantas/Alpachaca.jpeg').
iman('Granada', 'C:/Proyecto/plantas/Granada.jpeg').
iman('Muicle', 'C:/Proyecto/plantas/Muicle.jpeg').
iman('Monacillo', 'C:/Proyecto/plantas/Monacillo.jpeg').
iman('Naranja', 'C:/Proyecto/plantas/Naranja.jpeg').
iman('Tamarindo', 'C:/Proyecto/plantas/Tamarindo.jpeg').
iman('Ipecacuana', 'C:/Proyecto/plantas/Ipecacuana.jpeg').
iman('Lavanda', 'C:/Proyecto/plantas/Lavanda.jpeg').
iman('Torillo', 'C:/Proyecto/plantas/Torillo.jpeg').
iman('Alfalfa', 'C:/Proyecto/plantas/Alfalfa.jpeg').
iman('Pino', 'C:/Proyecto/plantas/Pino.jpeg').
iman('Belladona', 'C:/Proyecto/plantas/Belladona.jpeg').
iman('Helecho', 'C:/Proyecto/plantas/Helecho.jpeg').
iman('Acedera', 'C:/Proyecto/plantas/Acedera.jpeg').
iman('Azahar', 'C:/Proyecto/plantas/Azahar.jpeg').
iman('Ruibarbo', 'C:/Proyecto/plantas/Ruibarbo.jpeg').
iman('Esparrago', 'C:/Proyecto/plantas/Esparrago.jpeg').
iman('Brionia', 'C:/Proyecto/plantas/Brionia.jpeg').
iman('Ruda', 'C:/Proyecto/plantas/Ruda.jpeg').
iman('Verbena', 'C:/Proyecto/plantas/Verbena.jpeg').

iman('efectos', 'C:/Proyecto/plantas/efectos.jpeg').

iman('Abcesos','C:/Proyecto/enfermedades/abcesos.jpg').
iman('Abceso hepatico','C:/Proyecto/enfermedades/abceso_hepatico.jpg').
iman('Acidez estomacal','C:/Proyecto/enfermedades/acidez_estomacal.jpeg').
iman('Acido urico','C:/Proyecto/enfermedades/Acido urico.jpeg').
iman('Acne','C:/Proyecto/enfermedades/Acne.jpeg').
iman('Aftas','C:/Proyecto/enfermedades/Aftas.jpeg').
iman('Agotamiento','C:/Proyecto/enfermedades/Agotamiento.jpeg').
iman('Agruras','C:/Proyecto/enfermedades/Agruras.jpeg').
iman('Albuminaria','C:/Proyecto/enfermedades/Albuminaria.jpeg').
iman('Alcoholismo','C:/Proyecto/enfermedades/Alcoholismo.png').
iman('Almorranas','C:/Proyecto/enfermedades/Almorranas.jpeg').
iman('Anemia','C:/Proyecto/enfermedades/Anemia.jpeg').
iman('Anginas','C:/Proyecto/enfermedades/Anginas.jpeg').
iman('Anorexia','C:/Proyecto/enfermedades/Anorexia.jpeg').
iman('Arterosclerosis','C:/Proyecto/enfermedades/Arterosclerosis.jpeg').
iman('Artritis','C:/Proyecto/enfermedades/Artritis.jpeg').
iman('Asma','C:/Proyecto/enfermedades/Asma.jpeg').
iman('Atonia estomacal','C:/Proyecto/enfermedades/Atonia estomacal.jpeg').
iman('Bazo','C:/Proyecto/enfermedades/Bazo.jpeg').
iman('Inflamacion de boca','C:/Proyecto/enfermedades/Inflamacion de boca.jpeg').
iman('Estomatitis','C:/Proyecto/enfermedades/Estomatitis.jpeg').
iman('Perdida de cabello','C:/Proyecto/enfermedades/Perdida de cabello.jpeg').
iman('Calambres','C:/Proyecto/enfermedades/Calambres.jpeg').
iman('Calculos biliares','C:/Proyecto/enfermedades/Calculos biliares.jpeg').
iman('Calculos renales','C:/Proyecto/enfermedades/Calculos renales.jpeg').
iman('Callos','C:/Proyecto/enfermedades/Callos.jpeg').
iman('Caries','C:/Proyecto/enfermedades/Caries.jpeg').
iman('Caspa','C:/Proyecto/enfermedades/Caspa.jpeg').
iman('Cancer de utero','C:/Proyecto/enfermedades/Cancer de utero.jpeg').
iman('Ciatica','C:/Proyecto/enfermedades/Ciatica.jpeg').
iman('Circulacion','C:/Proyecto/enfermedades/Circulacion.jpeg').
iman('Cistitis','C:/Proyecto/enfermedades/Cistitis.jpeg').
iman('Colicos','C:/Proyecto/enfermedades/Colicos.jpeg').
iman('Colitis','C:/Proyecto/enfermedades/Colitis.jpeg').
iman('Contusiones','C:/Proyecto/enfermedades/Contusiones.jpeg').
iman('Corazon','C:/Proyecto/enfermedades/Corazon.jpeg').
iman('Diabetes','C:/Proyecto/enfermedades/Diabetes.jpeg').
iman('Diarrea cronica','C:/Proyecto/enfermedades/Diarrea.jpeg').
iman('Diarrea por irritacion','C:/Proyecto/enfermedades/Diarrea.jpeg').
iman('Diarrea por inflamacion','C:/Proyecto/enfermedades/Diarrea.jpeg').
iman('Diarrea Verdosa','C:/Proyecto/enfermedades/Diarrea.jpeg').
iman('Diarrea con sangre','C:/Proyecto/enfermedades/Diarrea.jpeg').
iman('Difteria','C:/Proyecto/enfermedades/Difteria.jpeg').
iman('Disenteria','C:/Proyecto/enfermedades/Disenteria.jpeg').
iman('Dispepsia','C:/Proyecto/enfermedades/Dispepsia.jpeg').
iman('Dolores musculares','C:/Proyecto/enfermedades/Dolores musculares.jpeg').
iman('Empacho','C:/Proyecto/enfermedades/Empacho.jpeg').
iman('Enteritis','C:/Proyecto/enfermedades/Enteritis.jpeg').
iman('Epilepsia','C:/Proyecto/enfermedades/Epilepsia.jpeg').
iman('Epistaxis','C:/Proyecto/enfermedades/Epistaxis.jpeg').
iman('Erisipela','C:/Proyecto/enfermedades/Erisipela.jpeg').
iman('Escarlatina','C:/Proyecto/enfermedades/Escarlatina.jpeg').
iman('Escorbuto','C:/Proyecto/enfermedades/Escorbuto.jpeg').
iman('Estreñimiento','C:/Proyecto/enfermedades/Estreñimiento.jpeg').
iman('Faringitis','C:/Proyecto/enfermedades/Faringitis.jpeg').
iman('Flatulencias','C:/Proyecto/enfermedades/Flatulencias.jpeg').
iman('Flebitis','C:/Proyecto/enfermedades/Flebitis.jpeg').
iman('Flemas','C:/Proyecto/enfermedades/Flemas.jpeg').
iman('Forunculos','C:/Proyecto/enfermedades/Forunculos.jpeg').
iman('Gastralgia','C:/Proyecto/enfermedades/Gastralgia.jpeg').
iman('Gonorrea','C:/Proyecto/enfermedades/Gonorrea.jpeg').
iman('Gota','C:/Proyecto/enfermedades/Gota.jpeg').
iman('Gripe','C:/Proyecto/enfermedades/Gripe.jpeg').
iman('Halitosis','C:/Proyecto/enfermedades/Halitosis.jpeg').
iman('Hemorragia interna','C:/Proyecto/enfermedades/Hemorragia interna.jpeg').
iman('Hepatitis','C:/Proyecto/enfermedades/Hepatitis.jpeg').
iman('Hernia','C:/Proyecto/enfermedades/hernia.jpeg').
iman('Herpes','C:/Proyecto/enfermedades/Herpes.jpeg').
iman('Heridas','C:/Proyecto/enfermedades/Heridas.jpeg').
iman('Hidropesia','C:/Proyecto/enfermedades/Hidropesia.jpeg').
iman('Congestion de higado','C:/Proyecto/enfermedades/Congestion de higado.jpeg').
iman('Hipertension','C:/Proyecto/enfermedades/Hipertension.jpeg').
iman('Hipotension','C:/Proyecto/enfermedades/Hipotension.jpeg').
iman('Hipo','C:/Proyecto/enfermedades/Hipo.jpeg').
iman('Histerismo','C:/Proyecto/enfermedades/Histerismo.jpeg').
iman('Insomnio','C:/Proyecto/enfermedades/Insomnio.jpeg').
iman('Intestino','C:/Proyecto/enfermedades/Intestino.jpeg').
iman('Impotencia sexual','C:/Proyecto/enfermedades/Impotencia sexual.jpeg').
iman('Jaqueca','C:/Proyecto/enfermedades/Jaqueca.jpeg').
iman('Lactancia','C:/Proyecto/enfermedades/Lactansia.jpeg').
iman('Laringitis','C:/Proyecto/enfermedades/Laringitis.jpeg').
iman('Leucorrea','C:/Proyecto/enfermedades/Leucorrea.jpeg').
iman('Lombrices','C:/Proyecto/enfermedades/Lombrices.jpeg').
iman('Lumbago','C:/Proyecto/enfermedades/Lumbago.jpeg').
iman('Llagas','C:/Proyecto/enfermedades/Llagas.jpeg').
iman('Malaria','C:/Proyecto/enfermedades/Malaria.jpeg').
iman('Menopausia','C:/Proyecto/enfermedades/Menopausia.jpeg').
iman('Menstruacion abundante','C:/Proyecto/enfermedades/Menstruacion.jpeg').
iman('Menstruacion dolorosa','C:/Proyecto/enfermedades/Menstruacion.jpeg').
iman('Menstruacion escasa','C:/Proyecto/enfermedades/Menstruacion.jpeg').
iman('Menstruacion irregular','C:/Proyecto/enfermedades/Menstruacion.jpeg').
iman('Muelas','C:/Proyecto/enfermedades/Muelas.jpeg').
iman('Hemorragia Nasal','C:/Proyecto/enfermedades/Hemorragia Nasal.jpeg').
iman('Nauseas','C:/Proyecto/enfermedades/Nauseas.jpeg').
iman('Neuralgias','C:/Proyecto/enfermedades/Neuralgias.jpeg').
iman('Neurastenia','C:/Proyecto/enfermedades/Neurastenia.jpeg').
iman('Nefritis','C:/Proyecto/enfermedades/Nefritis.jpeg').
iman('Obesidad','C:/Proyecto/enfermedades/Obesidad.jpeg').
iman('Oidos','C:/Proyecto/enfermedades/Oidos.jpeg').
iman('Conjuntivitis e irritacion','C:/Proyecto/enfermedades/Conjuntivitis.jpeg').
iman('Pies olorosos','C:/Proyecto/enfermedades/Pies olorosos.jpeg').
iman('Piquetes de abeja','C:/Proyecto/enfermedades/Piquetes.jpeg').
iman('Piquetes de araña','C:/Proyecto/enfermedades/Piquetes.jpeg').
iman('Piquetes de mosco','C:/Proyecto/enfermedades/Piquetes.jpeg').
iman('Pulmonia','C:/Proyecto/enfermedades/Pulmonia.jpeg').
iman('Quemaduras','C:/Proyecto/enfermedades/Quemaduras.jpeg').
iman('Raquitismo','C:/Proyecto/enfermedades/Raquitismo.jpeg').
iman('Reumatismo','C:/Proyecto/enfermedades/Reumatismo.jpeg').
iman('Riñones','C:/Proyecto/enfermedades/Riñones.jpeg').
iman('Ronquera','C:/Proyecto/enfermedades/Ronquera.png').
iman('Sabañones','C:/Proyecto/enfermedades/Sabañones.jpeg').
iman('Sarampion','C:/Proyecto/enfermedades/Sarampion.jpeg').
iman('Sarna','C:/Proyecto/enfermedades/Sarna.jpeg').
iman('Sarpullido','C:/Proyecto/enfermedades/Sarpullido.jpeg').
iman('Sed','C:/Proyecto/enfermedades/Sed.jpeg').
iman('Solitaria','C:/Proyecto/enfermedades/Solitaria.jpeg').
iman('Sudoracion excesiva','C:/Proyecto/enfermedades/Sudoracion.jpeg').
iman('Tifoidea','C:/Proyecto/enfermedades/Tifoidea.jpeg').
iman('Tina','C:/Proyecto/enfermedades/Tina.jpeg').
iman('Tos','C:/Proyecto/enfermedades/Tos.png').
iman('Tos Ferina','C:/Proyecto/enfermedades/Tos.png').
iman('Tuberculosis','C:/Proyecto/enfermedades/Tuberculosis.jpeg').
iman('Ulcera','C:/Proyecto/enfermedades/Ulcera.jpeg').
iman('Urticaria','C:/Proyecto/enfermedades/Urticaria.jpeg').
iman('Varices','C:/Proyecto/enfermedades/Varices.jpeg').
iman('Vejiga','C:/Proyecto/enfermedades/Vejiga.jpeg').
iman('Verrugas','C:/Proyecto/enfermedades/Verrugas.jpeg').
iman('Vertigos','C:/Proyecto/enfermedades/Vertigos.jpeg').
iman('Vomitos','C:/Proyecto/enfermedades/Vomitos.jpeg').
iman('Carencia de vitaminas','C:/Proyecto/enfermedades/Carencia de vitaminas.png').
iman('Botiquin','C:/Proyecto/enfermedades/Botiquin.jpeg').

iman('Digitalina','C:/Proyecto/medicamentos/Digitalina.jpeg').
iman('Emetina','C:/Proyecto/medicamentos/Emetina.jpeg').
iman('Estricnina','C:/Proyecto/medicamentos/Estricnina.jpeg').
iman('Veratrina','C:/Proyecto/medicamentos/Veratrina.jpeg').
iman('Colquicina','C:/Proyecto/medicamentos/Colquicina.jpeg').
iman('Atropina','C:/Proyecto/medicamentos/Atropina.jpeg').
iman('Quinina','C:/Proyecto/medicamentos/Quinina.jpeg').
iman('Teobromina','C:/Proyecto/medicamentos/Teobromina.jpeg').
iman('Esparteína','C:/Proyecto/medicamentos/Esparteína.jpeg').
iman('Cocaína','C:/Proyecto/medicamentos/Cocaína.jpeg').
iman('Mescalina','C:/Proyecto/medicamentos/Mescalina.jpeg').
iman('Efedrina','C:/Proyecto/medicamentos/Efedrina.jpeg').
iman('Hormonas','C:/Proyecto/medicamentos/Hormonas.jpeg').
iman('Lutenurina','C:/Proyecto/medicamentos/Lutenurina.jpeg').
iman('Diosponina','C:/Proyecto/medicamentos/Diosponina.png').
iman('Tavremisina','C:/Proyecto/medicamentos/Tavremisina.jpeg').
iman('Olitorisida','C:/Proyecto/medicamentos/Olitorisida.jpeg').
iman('Acido lisergico','C:/Proyecto/medicamentos/Ácido lisérgico.png').
iman('Eucaliptol','C:/Proyecto/medicamentos/Eucaliptol.jpeg').
iman('Quercitrina','C:/Proyecto/medicamentos/Quercitrina.jpeg').

%Función de cada opción del menú con sus estructuras y diseños
pp(Planta) :-
    new(D, dialog('Planta Medicinal')),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Planta, center, normal), point(320, 5)),
    nombre(Planta, Nombre),
    send(D, display, text('Su nombre científico es: ', center, normal), point(320, 30)),
    send(D, display, text(Nombre, center, normal), point(480, 30)),
    origen(Planta, Origen),
    send(D, display, text('Su origen es:', center, normal), point(320, 50)),
    send(D, display, text(Origen, center, normal), point(430, 50)),
    cura(Planta, Cura),
    send(D, display, text('Cura:', center, normal), point(320, 80)),
    send(D, display, text(Cura, center, normal), point(330, 100)),
    uso(Planta, Uso),
    send(D, display, text('Forma de uso/medicamentos:', center, normal), point(320, 160)),
    send(D, display, text(Uso, center, normal), point(500, 160)),

    iman(Planta, Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.

pp1(Efecto) :-
    new(D, dialog('Efectos')),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Efecto, center, normal), point(320, 5)),
    efectos(Efecto, Plantas),
    send(D, display, text('Las plantas que tienen el efecto solicitado son: ', center, normal), point(320, 60)),
    send(D, display, text(Plantas, center, normal), point(320, 80)),

    iman('efectos', Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.

pp2(Planta) :-
    new(D, dialog('Enfermedades')),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Planta, center, normal), point(320, 5)),
    cura(Planta, Cura),
    nombre(Planta, Nombre),
    send(D, display, text('Nombre científico: ', center, normal), point(320, 40)),
    send(D, display, text(Nombre, center, normal), point(430, 40)),
    send(D, display, text('Cura: ', center, normal), point(320, 60)),
    send(D, display, text(Cura, center, normal), point(340, 80)),
    iman(Planta, Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.

pp3(Planta) :-
    new(D, dialog(Planta)),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Planta, center, normal), point(320, 5)),
    uso(Planta, Uso),
    nombre(Planta, Nombre),
    send(D, display, text('Nombre científico: ', center, normal), point(320, 40)),
    send(D, display, text(Nombre, center, normal), point(430, 40)),
    send(D, display, text('Uso: ', center, normal), point(320, 60)),
    send(D, display, text(Uso, center, normal), point(340, 80)),
    iman(Planta, Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.
pp4(Enfermedad) :-
    new(D, dialog(Enfermedad)),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Enfermedad, center, normal), point(340, 5)),
    enfermedad(Enfermedad, Plantas),
    send(D, display, text('Plantas que curan la enfermedad dicha: ', center, normal), point(340, 60)),
    send(D, display, text(Plantas, center, normal), point(360, 80)),
    iman(Enfermedad, Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.

pp5(Medicamento) :-
    new(D, dialog(Medicamento)),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Medicamento, center, normal), point(320, 5)),
    medicamento(Planta, Medicamento),
    send(D, display, text('Planta que produce el medicamento: ', center, normal), point(320, 60)),
    send(D, display, text(Planta, center, normal), point(340, 80)),
    iman(Medicamento, Foto),
    mostrar(Foto, D, Menu),
    send(D, open, point(100, 100)),
    nl.

%Listas de Hechos
%Nombres cientificos de cada planta

nombre('Abrojo','Tribulus terrestris').
nombre('Acacia','--').
nombre('Acanto','Acanthus mollis').
nombre('Aceitilla','Bidens aurea').
nombre('Achicoria','Cichorium intybus').
nombre('Aconito','Aconitum napellus').
nombre('Ahuehuete','Taxodium mucronatum').
nombre('Anis','Pimpinella anisum').
nombre('Berro','Nasturtium officinale').
nombre('Canela','Cinnamomum verum').
nombre('Cedron','Aloysia citrodora').
nombre('Cola de caballo','Equisetum arvense').
nombre('Damiana','Turnera diffusa').
nombre('Diente de leon','Taraxacum officinale').
nombre('Doradilla','Asplenium ceterach').
nombre('Genciana','Gentiana').
nombre('Grama','Cynodon dactylon').
nombre('Linaza','Linum usitatissimum').
nombre('Manzanilla','Chamaemelum nobile').
nombre('Pinguica','Arctostaphylos pungens').
nombre('Romero','Salvia rosmarinus').
nombre('Salvia','--').
nombre('Sanguinaria','Sanguinaria canadensis').
nombre('Sensitiva','Mimosa pudica').
nombre('Simonillo','Erigeron bonariensis').
nombre('Tronadora','Tecoma stans').
nombre('Zarzaparrilla','Smilax aspera').
nombre('Malva','Malva sylvestris').
nombre('Perejil','Petroselinum crispum').
nombre('Limon','Citrus limon').
nombre('Sauco','Sambucus nigra').
nombre('Arnica','Arnica montana').
nombre('Llanten','Plantago major').
nombre('Fenogreco','Trigonella foenum-graecum').
nombre('Zarzamora','Rubus fruticosus').
nombre('Tib','Kefir').
nombre('Valeriana','Valeriana officinalis').
nombre('Yerbabuena','Mentha spicata').
nombre('Quina roja','Cinchona pubescens').
nombre('Encino rojo','Quercus rubra').
nombre('Pimiento','Capsicum annuum').
nombre('Hamamelis','Hamamelis virginiana').
nombre('Toques','Tagetes lucida').
nombre('Ajenjo','Artemisia absinthium').
nombre('Germen de trigo','Triticum aestivum').
nombre('Eucalipto','Eucalyptus globulus').
nombre('Cebada','Hordeum vulgare').
nombre('Tabachin','Delonix regia').
nombre('Borraja','Borago officinalis').
nombre('Cardo','Silybum marianum').
nombre('Chicalote','Argemone mexicana').
nombre('Alcanfor','Cinnamomum camphora').
nombre('Marrubio','Marrubium vulgare').
nombre('Oregano','Origanum vulgare').
nombre('Lupulo','Humulus lupulus').
nombre('Cuasia','Quassia amara').
nombre('Uva','Vitis vinifera').
nombre('Cerezo','Prunus avium').
nombre('Rosal','Rosa spp.').
nombre('Ortiga','Urtica dioica').
nombre('Espinosilla','Loeselia mexicana').
nombre('Retama','Spartium junceum').
nombre('Ajo','Allium sativum').
nombre('Cebolla','Allium cepa').
nombre('Hiedra','Hedera helix').
nombre('Siempreviva','Sempervivum tectorum').
nombre('Mastuerzo','Tropaeolum majus').
nombre('Higuera','Ficus carica').
nombre('Menta','Mentha piperita').
nombre('Hinojo','Foeniculum vulgare').
nombre('Boldo','Peumus boldus').
nombre('Matarique','Psacalium decompositum').
nombre('Alpachaca','Teloxys graveolens').
nombre('Granada','Punica granatum').
nombre('Muicle','Justicia spicigera').
nombre('Monacillo','Tecoma stans').
nombre('Naranja','Citrus sinensis').
nombre('Tamarindo','Tamarindus indica').
nombre('Ipecacuana','Psychotria ipecacuanha').
nombre('Lavanda','Lavandula angustifolia').
nombre('Torillo','Eryngium heterophyllum').
nombre('Alfalfa','Medicago sativa').
nombre('Pino','Pinus spp.').
nombre('Belladona','Atropa belladonna').
nombre('Helecho','Pteridium aquilinum').
nombre('Acedera','Rumex acetosa').
nombre('Azahar','Citrus aurantium').
nombre('Ruibarbo','Rheum rhabarbarum').
nombre('Esparrago','Asparagus officinalis').
nombre('Brionia','Bryonia dioica').
nombre('Ruda','Ruta graveolens').
nombre('Verbena','Verbena officinalis').


% Cuál planta cura qué enfermedad

cura('Abrojo','infecciones de pecho, inflamación de ojos, \ninflamación de hígado, favorece la circulación de la sangre').
cura('Acacia','Alivia dolor de garganta y evita que salgan \nampollas en las quemaduras').
cura('Acanto','Desinflama y saca el veneno de una picadura \nde araña').
cura('Aceitilla','Ayuda para mejorar el ánimo cuando se \nsufre de una depresión nerviosa o mortificación por estrés.').
cura('Achicoria','Ayuda en casos de Digestión Difícil, \ncólicos biliosos, estreñimiento porque purifica \nlos riñones y disminuye la bilis').
cura('Aconito','Se utiliza en jaquecas serias, dolor de \nmuelas, ciática, dolores articulares o hidropesía').
cura('Ahuehuete','Es recomendable en casos de varices, \nhemorroides, mala circulación.').
cura('Anis','favorece a que las mamás que están lactando \nproduzcan más leche y esta adormezca al bebé').
cura('Berro','Desinflama la boca, anginas, faringe, cura \ndolor de estómago en ayunas, descongestiona las \n mucosas, aumenta el apetito, y cura la anemia porque forma \nglóbulos rojos, también cura la sífilis y favorece la circulación').
cura('Canela','Ayuda en casos de anemia y debilidad, ayuda \n para la gripe, la digestión y los gases').
cura('Cedron','Ayuda a combatir cólicos, nauseas, flatulencias \ny mala digestión').
cura('Cola de caballo','Limpia la sangre, estómago, riñones y \nvejiga, arroja bilis, deshace cálculos y cura gonorreas').
cura('Damiana','Se utiliza más que nada como afrodisiaco, \nsin embargo se utiliza en diabetes, nefritis, orquitis y \nmales de la vejiga').
cura('Diente de leon','Es el depurativo y limpiador de sangre \nmás eficaz a la mano, purifica el hígado y los riñones, \nse recomienda para anémicos y débiles').
cura('Doradilla','Se usa con éxito en casos de cálculos biliares, \nafecciones de los riñones o vejiga, congestión o irritación \ndel hígado').
cura('Genciana','Ayuda a combatir el escorbuto, la anemia Gral., \nclorosis, debilidad, escrofulosis y leucorrea').
cura('Grama','Se usa la planta entera para curar golpes internos, \ninfecciones en los riñones, de orina y para desinflamar.').
cura('Linaza','Ayuda para los estreñimientos, colitis, males \nestomacales, bronquitis y hemorroides').
cura('Manzanilla','Favorece la digestión, la diarrea verde, \nregula la menstruación, la irritación de los ojos y \ncontrola los gases').
cura('Pinguica','Se recomienda en asuntos de riñones, vejiga \ninflamada, gonorrea, prostatitis e hidropesía.').
cura('Romero','Regulariza la menstruación, estimula la digestión \ny conforta los nervios (fumado ayuda en asma)').
cura('Salvia','Purificante, tónico y estomacal, muy bueno \npara activar el riñón e hígado').
cura('Sanguinaria','Ayuda a disolver los cálculos biliares, \npurificar y adelgazar la sangre y se usa para curar úlceras').
cura('Sensitiva','Ayudan a combatir el insomnio, el dolor de \nparto, el aire en el vientre.').
cura('Simonillo','Ictericia, catarro de las vías biliares, \ncólicos hepáticos, estreñimiento, no recomendable para \npersonas de la tercera edad').
cura('Tronadora','Antibilioso, antidiabético, bueno para la \nirritación por comer chile, ayuda para la gastritis \ny diabetes').
cura('Zarzaparrilla','Purificar la sangre, se usaba contra la sífilis.').
cura('Malva','Antiinflamatorio, emoliente y expectorante.').
cura('Perejil','Diurético, digestivo y \nantioxidante.').
cura('Limon','Antiséptico, digestivo y \nantioxidante.').
cura('Sauco','Expectorante, antiinflamatorio y \nantiviral.').
cura('Arnica','Antiinflamatorio y analgésico.').
cura('Llanten','Antiinflamatorio, cicatrizante \ny expectorante.').
cura('Fenogreco',' Digestivo, hipoglucemiante y galactógeno.').
cura('Zarzamora','Antioxidante, astringente y antiinflamatorio.').
cura('Tib','Probiótico, mejora la salud digestiva.').
cura('Valeriana','Sedante y ansiolítico.').
cura('Yerbabuena','Digestivo, antiespasmódico y carminativo.').
cura('Quina roja','Antimalárico y febrífugo.').
cura('Encino rojo','Astringente y antiinflamatorio.').
cura('Pimiento','Estimulante digestivo y antiinflamatorio.').
cura('Hamamelis','Astringente y antiinflamatorio.').
cura('Toques','Digestivo y antiinflamatorio.').
cura('Ajenjo','Digestivo y antiparasitario.').
cura('Germen de trigo','Nutricional, antioxidante y energético.').
cura('Eucalipto','Expectorante y antiséptico.').
cura('Cebada','Nutricional y digestivo.').
cura('Tabachin','Antiinflamatorio y antiespasmódico.').
cura('Borraja','Diurético y antiinflamatorio.').
cura('Cardo','Hepatoprotector y antioxidante.').
cura('Chicalote','Analgésico y sedante.').
cura('Alcanfor','Antiinflamatorio y analgésico.').
cura('Marrubio','Expectorante y digestivo.').
cura('Oregano','Antibacteriano y digestivo.').
cura('Lupulo','Sedante y digestivo.').
cura('Cuasia','Digestivo y antiparasitario.').
cura('Uva','Antioxidante y cardiovascular.').
cura('Cerezo','Antiinflamatorio y antioxidante.').
cura('Rosal','Antiinflamatorio y antioxidante.').
cura('Ortiga','Antiinflamatorio y diurético.').
cura('Espinosilla','Digestivo y antiinflamatorio.').
cura('Retama','Diurético y laxante.').
cura('Ajo','Antibacteriano y cardioprotector.').
cura('Cebolla','Antibacteriano y antioxidante.').
cura('Hiedra','Expectorante y antiespasmódico.').
cura('Siempreviva','Antiinflamatorio y cicatrizante').
cura('Mastuerzo','Antibacteriano y expectorante.').
cura('Higuera','Laxante y digestivo.').
cura('Menta','Digestivo y antiespasmódico.').
cura('Hinojo','Digestivo y carminativo.').
cura('Boldo','Digestivo y hepatoprotector.').
cura('Matarique','Antiinflamatorio y analgésico.').
cura('Alpachaca','Digestivo y antiinflamatorio.').
cura('Granada','Antioxidante y antiinflamatorio.').
cura('Muicle','Antiinflamatorio y digestivo.').
cura('Monacillo','Antidiabético y digestivo.').
cura('Naranja','Antioxidante y digestivo.').
cura('Tamarindo','Laxante y digestivo.').
cura('Ipecacuana','Emetico (induce el vómito) y expectorante.').
cura('Lavanda','Sedante, antiséptico y antiinflamatorio.').
cura('Torillo','Antiinflamatorio y digestivo.').
cura('Alfalfa','Nutricional, digestivo y diurético.').
cura('Pino','Expectorante, antiséptico y antiinflamatorio.').
cura('Belladona','Antiespasmódico y analgésico (uso \nrestringido por toxicidad)').
cura('Helecho','Antiinflamatorio y antihelmíntico (uso \nrestringido por potencial toxicidad).').
cura('Acedera','Digestivo y antioxidante.').
cura('Azahar','Sedante, ansiolítico y digestivo.').
cura('Ruibarbo','Laxante y digestivo.').
cura('Esparrago','Diurético y antioxidante.').
cura('Brionia','Laxante y expectorante (uso restringido por toxicidad).').
cura('Ruda','Antiespasmódico, emenagogo y \nantiinflamatorio (uso restringido \npor potencial toxicidad).').
cura('Verbena','Digestivo, sedante y antiinflamatorio.').

%Origen de cada planta

origen('Abrojo','Áreas Arenosas y pedregosas en regiones frías y templadas de México').
origen('Acacia','Griego').
origen('Acanto','Griego').
origen('Aceitilla','Aparece en los sembradíos en los meses de agosto a octubre.').
origen('Achicoria','--').
origen('Aconito','--').
origen('Ahuehuete','--').
origen('Anis','Griego').
origen('Berro','Sirio-Libanes').
origen('Canela','--').
origen('Cedron','--').
origen('Cola de caballo','--').
origen('Damiana','--').
origen('Diente de leon','--').
origen('Doradilla','--').
origen('Genciana','--').
origen('Grama','Crece como zacate en casi toda America').
origen('Linaza','Egipcio').
origen('Manzanilla','Europa').
origen('Pinguica','--').
origen('Romero','--').
origen('Salvia','--').
origen('Sanguinaria','--').
origen('Sensitiva','--').
origen('Simonillo','--').
origen('Tronadora','--').
origen('Zarzaparrilla','--').
origen('Malva','Europa, norte de África y Asia.').
origen('Perejil','Región mediterránea.').
origen('Limon','Asia.').
origen('Sauco','Europa y América del Norte.').
origen('Arnica','Europa y Siberia.').
origen('Llanten','Europa y Asia.').
origen('Fenogreco','Región mediterránea y Asia occidental.').
origen('Zarzamora','Europa, Asia y América del Norte.').
origen('Tib','Región del Cáucaso.').
origen('Valeriana','Europa y Asia.').
origen('Yerbabuena','Europa y Asia.').
origen('Quina roja','Andes de América del Sur.').
origen('Encino rojo','América del Norte.').
origen('Pimiento','América.').
origen('Hamamelis','América del Norte.').
origen('Toques','América Central y México.').
origen('Ajenjo','Europa, Asia y norte de África.').
origen('Germen de trigo','Oriente Medio.').
origen('Eucalipto','Australia.').
origen('Cebada','Medio Oriente.').
origen('Tabachin','Madagascar.').
origen('Borraja','Región mediterránea.').
origen('Cardo','Región mediterránea.').
origen('Chicalote','México y América Central.').
origen('Alcanfor','Asia.').
origen('Marrubio','Europa, norte de África y Asia.').
origen('Oregano','Región mediterránea.').
origen('Lupulo','Europa y Asia occidental.').
origen('Cuasia','América del Sur y Central.').
origen('Uva','Región mediterránea.').
origen('Cerezo','Europa y Asia occidental.').
origen('Rosal','Asia.').
origen('Ortiga','Europa, Asia y América del Norte.').
origen('Espinosilla','México.').
origen('Retama','Región mediterránea.').
origen('Ajo','Asia central.').
origen('Cebolla','Asia.').
origen('Hiedra','Europa y Asia.').
origen('Siempreviva','Europa.').
origen('Mastuerzo','América del Sur.').
origen('Higuera','Asia occidental.').
origen('Menta','Europa.').
origen('Hinojo','Región mediterránea.').
origen('Boldo','América del Sur.').
origen('Matarique','México.').
origen('Alpachaca','América del Norte.').
origen('Granada','Región mediterránea y Asia.').
origen('Muicle','México y América Central.').
origen('Monacillo','América.').
origen('Naranja','Asia.').
origen('Tamarindo','África tropical.').
origen('Ipecacuana','América del Sur.').
origen('Lavanda','Región mediterránea.').
origen('Torillo','México.').
origen('Alfalfa','Asia.').
origen('Pino','Hemisferio Norte.').
origen('Belladona','Europa').
origen('Helecho','--').
origen('Acedera','Europa y Asia.').
origen('Azahar','Asia.').
origen('Ruibarbo','Asia.').
origen('Esparrago','Europa').
origen('Brionia','Europa').
origen('Ruda','--').
origen('Verbena','Europa').

%Efectos que tienen las plantas

efectos('Antidepresivo', 'Abrojo, Sensitiva').
efectos('Digestivo', 'Acacia, Ahuehuete, Anis, Doradilla, Genciana, \nLinaza, Salvia, Simonillo, Perejil, Limon\n, Fenogreco, Yerbabuena, Pimiento, Toques \n Ajenjo, Cebada, Marrubio, Oregano, Manzanilla').
efectos('Analgesico', 'Acanto, Romero').
efectos('Problemas circulatorios','Aceitilla').
efectos('Antiespasmodico', 'Achicoria, Sensitiva').
efectos('Antiinflamatorio','Aconito, Diente de leon, Arnica\nLlanten, Zarzamora, Encino rojo, Pimiento\n Hamamelis, Toques, Tabachin, Borraja').
efectos('Antioxidante', 'Berro, Perejil, Limon, Zarzamora\n Germen de trigo,Cardo, Uva, Cerezo, Rosal\n Cebolla, Granada, Naranja').
efectos('Afrodisiaco', 'Canela, Romero').
efectos('Depurativo', 'Cedron, Cola de caballo').
efectos('Diuretico', 'Damiana').
efectos('Antiseptico', 'Grama').
efectos('Purificante', 'Manzanilla, Pinguica, \nZarzaparrilla, Sanguinaria').
efectos('Antibilioso', 'Tronadora').

% Uso de las plantas medicinalmente

uso('Abrojo','Cocer un poco la raíz y \nservir en agua').
uso('Acacia','Una piza de polvo de la \nplanta revuelta de clara de huevo \nformando una cataplasma puesta sobre la quemadura').
uso('Acanto','para la picadura es directamente \nlas hojas pero si se hace un té se combaten \nlas almorranas, ardores de orina, heridas por golpes, etc. \nsirve para desinflamar y curar los golpes').
uso('Aceitilla','En té').
uso('Achicoria','Se cuecen las hojas secas \ny se come en ensalada o se pueden cocer las hojas \nverdes y se toma en té').
uso('Aconito','Para el dolor de muelas se \nfrota la encía con el extracto y se introduce en las caries \nun algodón empapado en acónito').
uso('Ahuehuete','Té de 3 a 4 veces al día').
uso('Anis','En té').
uso('Berro','Se comen las hojas crudas').
uso('Canela','En té').
uso('Cedron','En té con las hojas frescas \no secadas a la sombra').
uso('Cola de caballo','Té con las hojas').
uso('Damiana','En té').
uso('Diente de leon','Se utiliza toda la planta \npara hacer té').
uso('Doradilla','Se usa toda la planta con todo \ny raíz para hacer un té que se toma después \nde las comidas').
uso('Genciana','la raíz se pone a remojar toda \nla noche y suelta su contenido para estimular el \napetito. también como se usa \nnormalmente es en un té').
uso('Grama','Se toma como agua de uso').
uso('Linaza','Hacer una infusión que se toma en \ntraguitos durante todo el día').
uso('Manzanilla','En Té').
uso('Pinguica','Se usan hojas y fruto en té').
uso('Romero','En té normal, fumado para asma \ny en tinte al 10% para evitar la caída del pelo').
uso('Salvia','Masticada purifica el aliento y \nlimpia los dientes').
uso('Sanguinaria','Se usa como té durante \n15 días').
uso('Sensitiva','Se cosen las hojas frescas y \nla raíz para hacer un té').
uso('Simonillo','Se utiliza toda la planta \npara hacer té').
uso('Tronadora','En té').
uso('Zarzaparrilla','Se usa la raíz para \nhacer un té').
uso('Malva','Infusión de las hojas y flores.').
uso('Perejil','Infusión de las hojas frescas o secas.').
uso('Limon','Jugo fresco o infusión de la cáscara.').
uso('Sauco','Infusión de las flores y bayas.').
uso('Arnica','Uso tópico en forma de pomada o gel.').
uso('Llanten','Infusión de las hojas.').
uso('Fenogreco','Infusión de las semillas.').
uso('Zarzamora','Infusión de las hojas y consumo de los frutos.').
uso('Tib','Fermentación de leche o agua azucarada con \nlos nódulos de kefir.').
uso('Valeriana','Infusión de la raíz.').
uso('Yerbabuena','Infusión de las hojas.').
uso('Quina roja','Infusión de la corteza.').
uso('Encino rojo','Decocción de la corteza.').
uso('Pimiento','Infusión de los frutos secos.').
uso('Hamamelis','Infusión de las hojas y corteza.').
uso('Toques','Infusión de las hojas y flores.').
uso('Ajenjo','Infusión de las hojas.').
uso('Germen de trigo','Consumo directo en alimentos o bebidas.').
uso('Eucalipto','Infusión de las hojas.').
uso('Cebada','Infusión de los granos o germen.').
uso('Tabachin','Infusión de las flores y hojas.').
uso('Borraja','Infusión de las hojas y flores.').
uso('Cardo','Infusión de las semillas.').
uso('Chicalote','Infusión de las hojas y flores.').
uso('Alcanfor','Uso tópico en pomadas y ungüentos.').
uso('Marrubio','Infusión de las hojas y flores.').
uso('Oregano','Infusión de las hojas y flores.').
uso('Lupulo','Infusión de las flores (conos).').
uso('Cuasia','Infusión de la corteza.').
uso('Uva','Consumo directo del fruto o jugo.').
uso('Cerezo','Infusión de los pedúnculos o consumo directo del fruto.').
uso('Rosal','Infusión de los pétalos y caderas (frutos).').
uso('Ortiga','Infusión de las hojas.').
uso('Espinosilla','Infusión de las hojas y flores.').
uso('Retama','Infusión de las flores.').
uso('Ajo','Consumo crudo o en infusión.').
uso('Cebolla','Consumo crudo o en infusión.').
uso('Hiedra','Infusión de las hojas.').
uso('Siempreviva','Uso tópico de las hojas trituradas').
uso('Mastuerzo','Infusión de las hojas y flores.').
uso('Higuera','Consumo del fruto o infusión de las hojas.').
uso('Menta','Infusión de las hojas.').
uso('Hinojo','Infusión de las semillas.').
uso('Boldo','Infusión de las hojas.').
uso('Matarique','Infusión de las raíces.').
uso('Alpachaca','Infusión de las hojas.').
uso('Granada','Consumo del fruto o infusión de la cáscara.').
uso('Muicle','Infusión de las hojas y flores.').
uso('Monacillo','Infusión de las hojas y flores.').
uso('Naranja','Consumo del fruto o infusión de la cáscara.').
uso('Tamarindo','Consumo del fruto o infusión.').
uso('Ipecacuana','Infusión de la raíz seca').
uso('Lavanda','Infusión de las flores secas').
uso('Torillo','Infusión de las hojas y raíces.').
uso('Alfalfa','Infusión de las hojas y brotes frescos o secos').
uso('Pino','Infusión de las agujas o resina en agua caliente.').
uso('Belladona','Uso muy controlado bajo supervisión\n médica; normalmente se utiliza en forma de extracto.').
uso('Helecho','Infusión de las hojas (bajo supervisión médica).').
uso('Acedera','Infusión de las hojas frescas o secas.').
uso('Azahar','Infusión de las flores frescas o secas.').
uso('Ruibarbo','Infusión de los tallos (las hojas son tóxicas).').
uso('Esparrago','Consumo del brote fresco o infusión de los brotes.').
uso('Brionia','Uso muy controlado bajo supervisión\n médica; normalmente se utiliza \nen forma de extracto.').
uso('Ruda','Infusión de las hojas (bajo supervisión médica).').
uso('Verbena','Infusión de las hojas y flores frescas o secas.').

%Enfermedades y Plantas que ayudan

enfermedad('Abcesos','Malva').
enfermedad('Abceso hepatico','Zarzaparrilla').
enfermedad('Acidez estomacal','Anis, Perejil').
enfermedad('Acido urico','Sanguinaria, Limón, Sauco').
enfermedad('Acne','Árnica').
enfermedad('Aftas','Llantén, Fenogreco, Zarzamora').
enfermedad('Agotamiento','Salvia, Tib, Valeriana').
enfermedad('Agruras','Yerbabuena, Manzanilla, Jugo de limón o toronja').
enfermedad('Albuminaria','Pingüica, Quina roja, Encino rojo').
enfermedad('Alcoholismo','Pimiento').
enfermedad('Almorranas','Salvia, Hamamelis, Sanguinaria, \nCola de caballo, Árnica, Toques, Sauco').
enfermedad('Anemia','Ajenjo, Germen de trigo, Quina,\n Canela, Alholva').
enfermedad('Anginas','Eucalipto, Cebada, Salvia, Tabachín, Borraja').
enfermedad('Anorexia','Ajenjo, Genciana, Yerbabuena').
enfermedad('Arterosclerosis','Limón, Genciana, Cardo, Zarzaparrilla').
enfermedad('Artritis','Árnica, Chicalote, Alcanfor, Toronja').
enfermedad('Asma','Eucalipto, Marrubio, Toloache, \nOrégano, Salvia').
enfermedad('Atonia estomacal','Lúpulo, Eucalipto, Cuasia').
enfermedad('Bazo','Uva, Cerezo').
enfermedad('Inflamacion de boca','Malva, Rosal, Limón, Salvia').
enfermedad('Estomatitis','Rosal, Encina, Salvia, Zarzamora').
enfermedad('Perdida de cabello','Ortiga, Espinosilla, Marrubio, Romero').
enfermedad('Calambres','Anís, Tila, Manzanilla, Ajenjo').
enfermedad('Calculos biliares','Diente de león, Aceite de oliva, Retama').
enfermedad('Calculos renales','Cabellos de elote, Pingüica, Cola de caballo').
enfermedad('Callos','Ajo, Cebolla').
enfermedad('Caries','Hiedra, Cola de caballo').
enfermedad('Caspa','Ortiga, Limón, Romero').
enfermedad('Cancer de utero','Cachalote, Llantén, Siempreviva').
enfermedad('Ciatica','Mastuerzo, Higuera, Sauco').
enfermedad('Circulacion','Toronjil, Sanguinaria, Salvia, Hamamelis').
enfermedad('Cistitis','Cola de caballo, Doradilla, Ajo, Cabellos de elote').
enfermedad('Colicos','Menta, Hinojo, Manzanilla, Toronjil, Boldo').
enfermedad('Colitis','Linaza, Anís, Romero, Cola de caballo').
enfermedad('Contusiones','Árnica, Hamamelis, Laurel, Brionia').
enfermedad('Corazon','Salvia, Nuez de kola, Tejocote').
enfermedad('Diabetes','Matarique, Tronadora, Eucalipto, Damiana').
enfermedad('Diarrea cronica','Capulín, Corteza de mezquite, Tlachicholes').
enfermedad('Diarrea por irritacion','Linaza, Membrillo, Arroz, Cebada').
enfermedad('Diarrea por inflamacion','Guayaba, Alpachaca, Granada').
enfermedad('Diarrea Verdosa','Manzanilla, Simonillo, Capullo de siempreviva').
enfermedad('Diarrea con sangre','Chaparro amargoso, Muicle, Monacillo').
enfermedad('Difteria','Limón, Naranja').
enfermedad('Disenteria','Tamarindo, Chaparro amargoso, Ipecacuana, Cedrón').
enfermedad('Dispepsia','Anís, Menta, Yerbabuena, Té de limón').
enfermedad('Dolores musculares','Alcanfor').
enfermedad('Empacho','Tamarindo').
enfermedad('Enteritis','Linaza, Cedrón, Llantén').
enfermedad('Epilepsia','Valeriana').
enfermedad('Epistaxis','Hierba del pollo, Cebolla, Perejil').
enfermedad('Erisipela','Sauco, Hiedra, Zanahoria').
enfermedad('Escarlatina','Borraja, Sauco, Cebolla').
enfermedad('Escorbuto','Aso, Limón, Berro, Cebolla, Geranio').
enfermedad('Estreñimiento','Ciruela, Linaza, Chía, Tamarindo, Agar-agar').
enfermedad('Faringitis','Eucalipto, Lavanda, Anacahuite').
enfermedad('Flatulencias','Apo, Torillo, Perejil, \nAnís estrella, Hinojo, Toronjil, \nRomero, Ruibarbo, Ruda, Menta').
enfermedad('Flebitis','Árnica, Alfalfa, Lino, Malvavisco, Romero, Quina').
enfermedad('Flemas','Genciana, Orégano').
enfermedad('Forunculos','Fenogreco, Malvavisco, Hiedra').
enfermedad('Gastralgia','Manzanilla, Anís estrella').
enfermedad('Gonorrea','Cola de caballo, Doradilla, Zarzaparrilla').
enfermedad('Gota','Apio, Cerezo, Limón, Pino,\n Alcanfor, Acónito, Belladona, Beleño, \nCólchico, Chicalote').
enfermedad('Gripe','Eucalipto, Limón, Quina, Zarzaparrilla, \nCaléndula').
enfermedad('Halitosis','Hinojo, Menta').
enfermedad('Hemorragia interna','Mastuerzo, Ortiga, Rosal').
enfermedad('Hepatitis','Retama, Boldo, Alcachofa, Prodigiosa, Cáscara sagrada').
enfermedad('Hernia','Helecho, Ricino, Tabaco').
enfermedad('Herpes','Linaza, Llantén').
enfermedad('Heridas','Árnica, Hamamelis').
enfermedad('Hidropesia','Alcachofa, Cardo, Perejil, Sauco, Berro, Retama').
enfermedad('Congestion de higado','Marrubio, Boldo, Doradilla, Ruibarbo').
enfermedad('Hipertension','Espárrago, Alpiste, Muérdago').
enfermedad('Hipotension','Miel, Nuez de kola, Acedera').
enfermedad('Hipo','Anís, Hinojo, Tila, Valeriana').
enfermedad('Histerismo','Azahar, Beleño, Tila, Valeriana').
enfermedad('Insomnio','Pasiflora, Azahar, Menta, Manzanilla,\n Lechuga, Tila').
enfermedad('Intestino','Genciana, Melisa').
enfermedad('Impotencia sexual','Yohimbo, Nuez vómica, Aguacate').
enfermedad('Jaqueca','Manzanilla, Acónito, Valeriana,\n Tila, Chicalote').
enfermedad('Lactancia','Hinojo, Anís, Menta, Perejil, Zanahoria').
enfermedad('Laringitis','Acónito, Borraja, Cebolla rosa, \nBenjuí, Encino').
enfermedad('Leucorrea','Encina, Zarzaparrilla, Pino, Enebro, Genciana').
enfermedad('Lombrices','Ajenjo, Ajo, Brionia, Aguacate, Papaya').
enfermedad('Lumbago','Avena, Cebada, Tomillo, Verbena, Epazote').
enfermedad('Llagas','Fenogreco, Eucalipto, Llantén, Sanguinaria').
enfermedad('Malaria','Quina, Girasol, Eucalipto').
enfermedad('Menopausia','Azahar, Hamamelis, Tila, Quina roja').
enfermedad('Menstruacion abundante','Azafrán, Hamamelis').
enfermedad('Menstruacion dolorosa','Belladona, Anís estrella').
enfermedad('Menstruacion escasa','Ruda, Ajenjo, Manzanilla').
enfermedad('Menstruacion irregular','Apo, Hisopo, Quina \namarilla, Sabina, Artemisa').
enfermedad('Muelas','Clavo, Hiedra').
enfermedad('Hemorragia Nasal','Ortiga, Cola de caballo, Ruda, Eucalipto').
enfermedad('Nauseas','Anís, Ajenjo, Menta, Salvia').
enfermedad('Neuralgias','Manzanilla, Menta, Valeriana, Boldo').
enfermedad('Neurastenia','Pasiflora, Té negro, Mate, Valeriana').
enfermedad('Nefritis','Linaza, Grama, Cebada, Llantén,\n Doradilla, Espárrago, Ruda').
enfermedad('Obesidad','Toronjil, Marrubio, Limón, Malva, Espárrago').
enfermedad('Oidos','Boldo, Aceite de oliva, Llantén, Hiedra').
enfermedad('Conjuntivitis e irritacion','Manzanilla, Limón, Llantén,\n Salvia, Ruda, Rosal').
enfermedad('Pies olorosos','Laurel, Encina').
enfermedad('Piquetes de abeja','Miel, Perejil, Cebolla, Puerco').
enfermedad('Piquetes de araña','Fresno, Ipecacuana').
enfermedad('Piquetes de mosco','Alcanfor, Perejil, Hamamelis').
enfermedad('Pulmonia','Eucalipto, Ocote, Gordolobo, Borraja, Sauco').
enfermedad('Quemaduras','Linaza, Cebolla, Hiedra').
enfermedad('Raquitismo','Nogal').
enfermedad('Reumatismo','Ajo, Apio, Borraja, Gobernadora, \nPino, Romero, Sanguinaria, Marrubio, Tabaco').
enfermedad('Riñones','Cabellos de elote, Cola de caballo, Apio').
enfermedad('Ronquera','Eucalipto, Pino, Gordolobo').
enfermedad('Sabañones','Ajo, Cebolla').
enfermedad('Sarampion','Borraja, Ortiga, Sauco').
enfermedad('Sarna','Ajo, Alcanfor, Menta, Tomillo, Romero').
enfermedad('Sarpullido','Encina, Salvia, Tila').
enfermedad('Sed','Limón, Tamarindo, Pirul').
enfermedad('Solitaria','Semilla de calabaza, Gramado, Coquito\n de aceite, Helecho macho').
enfermedad('Sudoracion excesiva','Encina').
enfermedad('Tifoidea','Alcanfor, Borraja, Quina, Canela, Romero, Salvia').
enfermedad('Tina','Berro, Tila, Tamarindo, Salvia').
enfermedad('Tos','Eucalipto, Capulín, Cedrón, Salvia, \nMalva, Marrubio').
enfermedad('Tos Ferina','Gelsemio, Quina, Rábano, Violeta').
enfermedad('Tuberculosis','Mastuerzo, Berro, Ajo, Eucalipto,\n Pirul, Pino, Roble').
enfermedad('Ulcera','Cuachalalate, Sanguinaria, Cola de caballo, Girasol').
enfermedad('Urticaria','Limón, Ruibarbo').
enfermedad('Varices','Hamamelis, Castaño de Indias, Llantén,\n Toronjil').
enfermedad('Vejiga','Apio, Ciprés, Cola de caballo, Ortiga, Malva').
enfermedad('Verrugas','Leche de higuera, Cebolla, Nogal').
enfermedad('Vertigos','Albahaca, Espino').
enfermedad('Vomitos','Menta, Tila, Marrubio, Valeriana, Salvia').
enfermedad('Carencia de vitaminas','Alfalfa, Espinacas, Acelga,\n Berro, Cebolla, Limón, Zanahoria').

%Medicamento que se produce con plantas
medicamento('Digital','Digitalina').
medicamento('Ipeca','Emetina').
medicamento('Mez Vomica','Estricnina').
medicamento('Eleboro Banco','Veratrina').
medicamento('Colchico','Colquicina').
medicamento('Belladona','Atropina').
medicamento('Quina','Quinina').
medicamento('Cacao','Teobromina').
medicamento('Retama','Esparteína').
medicamento('Coca','Cocaína').
medicamento('Peyote','Mescalina').
medicamento('Efedra','Efedrina').
medicamento('Barbasco','Hormonas').
medicamento('Nenúfar Amarillo','Lutenurina').
medicamento('Ñame','Diosponina').
medicamento('Artemisa','Tavremisina').
medicamento('Semilla de Yute','Olitorisida').
medicamento('Toloache','Ácido lisérgico').
medicamento('Eucalipto','Eucaliptol').
medicamento('Rosal','Quercitrina').
medicamento('Acido lisergico','LCD').





































