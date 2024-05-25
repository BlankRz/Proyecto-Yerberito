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

%Funciones para hacer funcionar el men�
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



%Funcion principal y dise�o de la p�gina principal
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
    send(D, display, text('Sistema Experto\nEl Yerberito Ilustrado\n\nElaborado por:\nMaria Guadalupe  Gonzalez Hern�ndez\nBlanca Isabel Hern�ndez Ruiz\nGerm�n Jim�nez Torres', center, normal), point(320, 160)),
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
    send(D, display, text('Plantas que podr�an servir en casa:', center, normal), point(320, 5)),
    send(D, display, text('Anis estrella, Menta arnica, Salvia, Tila, Eucalipto, \nYerbabuena, Manzanilla, Cola de caballo, Romero, Toronjil,\n Sanguinaria, Linaza, Hamamelis, Zarzaparrilla, Boldo, \nDiente de le�n, Azahar, Malva,�Marrubio,�Rosal ', center, normal), point(320, 60)),
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
iman('Estre�imiento','C:/Proyecto/enfermedades/Estre�imiento.jpeg').
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
iman('Piquetes de ara�a','C:/Proyecto/enfermedades/Piquetes.jpeg').
iman('Piquetes de mosco','C:/Proyecto/enfermedades/Piquetes.jpeg').
iman('Pulmonia','C:/Proyecto/enfermedades/Pulmonia.jpeg').
iman('Quemaduras','C:/Proyecto/enfermedades/Quemaduras.jpeg').
iman('Raquitismo','C:/Proyecto/enfermedades/Raquitismo.jpeg').
iman('Reumatismo','C:/Proyecto/enfermedades/Reumatismo.jpeg').
iman('Ri�ones','C:/Proyecto/enfermedades/Ri�ones.jpeg').
iman('Ronquera','C:/Proyecto/enfermedades/Ronquera.png').
iman('Saba�ones','C:/Proyecto/enfermedades/Saba�ones.jpeg').
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
iman('Esparte�na','C:/Proyecto/medicamentos/Esparte�na.jpeg').
iman('Coca�na','C:/Proyecto/medicamentos/Coca�na.jpeg').
iman('Mescalina','C:/Proyecto/medicamentos/Mescalina.jpeg').
iman('Efedrina','C:/Proyecto/medicamentos/Efedrina.jpeg').
iman('Hormonas','C:/Proyecto/medicamentos/Hormonas.jpeg').
iman('Lutenurina','C:/Proyecto/medicamentos/Lutenurina.jpeg').
iman('Diosponina','C:/Proyecto/medicamentos/Diosponina.png').
iman('Tavremisina','C:/Proyecto/medicamentos/Tavremisina.jpeg').
iman('Olitorisida','C:/Proyecto/medicamentos/Olitorisida.jpeg').
iman('Acido lisergico','C:/Proyecto/medicamentos/�cido lis�rgico.png').
iman('Eucaliptol','C:/Proyecto/medicamentos/Eucaliptol.jpeg').
iman('Quercitrina','C:/Proyecto/medicamentos/Quercitrina.jpeg').

%Funci�n de cada opci�n del men� con sus estructuras y dise�os
pp(Planta) :-
    new(D, dialog('Planta Medicinal')),
    send(D, size, size(660, 300)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text(Planta, center, normal), point(320, 5)),
    nombre(Planta, Nombre),
    send(D, display, text('Su nombre cient�fico es: ', center, normal), point(320, 30)),
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
    send(D, display, text('Nombre cient�fico: ', center, normal), point(320, 40)),
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
    send(D, display, text('Nombre cient�fico: ', center, normal), point(320, 40)),
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


% Cu�l planta cura qu� enfermedad

cura('Abrojo','infecciones de pecho, inflamaci�n de ojos, \ninflamaci�n de h�gado, favorece la circulaci�n de la sangre').
cura('Acacia','Alivia dolor de garganta y evita que salgan \nampollas en las quemaduras').
cura('Acanto','Desinflama y saca el veneno de una picadura \nde ara�a').
cura('Aceitilla','Ayuda para mejorar el �nimo cuando se \nsufre de una depresi�n nerviosa o mortificaci�n por estr�s.').
cura('Achicoria','Ayuda en casos de Digesti�n Dif�cil, \nc�licos biliosos, estre�imiento porque purifica \nlos ri�ones y disminuye la bilis').
cura('Aconito','Se utiliza en jaquecas serias, dolor de \nmuelas, ci�tica, dolores articulares o hidropes�a').
cura('Ahuehuete','Es recomendable en casos de varices, \nhemorroides, mala circulaci�n.').
cura('Anis','favorece a que las mam�s que est�n lactando \nproduzcan m�s leche y esta adormezca al beb�').
cura('Berro','Desinflama la boca, anginas, faringe, cura \ndolor de est�mago en ayunas, descongestiona las \n mucosas, aumenta el apetito, y cura la anemia porque forma \ngl�bulos rojos, tambi�n cura la s�filis y favorece la circulaci�n').
cura('Canela','Ayuda en casos de anemia y debilidad, ayuda \n para la gripe, la digesti�n y los gases').
cura('Cedron','Ayuda a combatir c�licos, nauseas, flatulencias \ny mala digesti�n').
cura('Cola de caballo','Limpia la sangre, est�mago, ri�ones y \nvejiga, arroja bilis, deshace c�lculos y cura gonorreas').
cura('Damiana','Se utiliza m�s que nada como afrodisiaco, \nsin embargo se utiliza en diabetes, nefritis, orquitis y \nmales de la vejiga').
cura('Diente de leon','Es el depurativo y limpiador de sangre \nm�s eficaz a la mano, purifica el h�gado y los ri�ones, \nse recomienda para an�micos y d�biles').
cura('Doradilla','Se usa con �xito en casos de c�lculos biliares, \nafecciones de los ri�ones o vejiga, congesti�n o irritaci�n \ndel h�gado').
cura('Genciana','Ayuda a combatir el escorbuto, la anemia Gral., \nclorosis, debilidad, escrofulosis y leucorrea').
cura('Grama','Se usa la planta entera para curar golpes internos, \ninfecciones en los ri�ones, de orina y para desinflamar.').
cura('Linaza','Ayuda para los estre�imientos, colitis, males \nestomacales, bronquitis y hemorroides').
cura('Manzanilla','Favorece la digesti�n, la diarrea verde, \nregula la menstruaci�n, la irritaci�n de los ojos y \ncontrola los gases').
cura('Pinguica','Se recomienda en asuntos de ri�ones, vejiga \ninflamada, gonorrea, prostatitis e hidropes�a.').
cura('Romero','Regulariza la menstruaci�n, estimula la digesti�n \ny conforta los nervios (fumado ayuda en asma)').
cura('Salvia','Purificante, t�nico y estomacal, muy bueno \npara activar el ri��n e h�gado').
cura('Sanguinaria','Ayuda a disolver los c�lculos biliares, \npurificar y adelgazar la sangre y se usa para curar �lceras').
cura('Sensitiva','Ayudan a combatir el insomnio, el dolor de \nparto, el aire en el vientre.').
cura('Simonillo','Ictericia, catarro de las v�as biliares, \nc�licos hep�ticos, estre�imiento, no recomendable para \npersonas de la tercera edad').
cura('Tronadora','Antibilioso, antidiab�tico, bueno para la \nirritaci�n por comer chile, ayuda para la gastritis \ny diabetes').
cura('Zarzaparrilla','Purificar la sangre, se usaba contra la s�filis.').
cura('Malva','Antiinflamatorio, emoliente y expectorante.').
cura('Perejil','Diur�tico, digestivo y \nantioxidante.').
cura('Limon','Antis�ptico, digestivo y \nantioxidante.').
cura('Sauco','Expectorante, antiinflamatorio y \nantiviral.').
cura('Arnica','Antiinflamatorio y analg�sico.').
cura('Llanten','Antiinflamatorio, cicatrizante \ny expectorante.').
cura('Fenogreco',' Digestivo, hipoglucemiante y galact�geno.').
cura('Zarzamora','Antioxidante, astringente y antiinflamatorio.').
cura('Tib','Probi�tico, mejora la salud digestiva.').
cura('Valeriana','Sedante y ansiol�tico.').
cura('Yerbabuena','Digestivo, antiespasm�dico y carminativo.').
cura('Quina roja','Antimal�rico y febr�fugo.').
cura('Encino rojo','Astringente y antiinflamatorio.').
cura('Pimiento','Estimulante digestivo y antiinflamatorio.').
cura('Hamamelis','Astringente y antiinflamatorio.').
cura('Toques','Digestivo y antiinflamatorio.').
cura('Ajenjo','Digestivo y antiparasitario.').
cura('Germen de trigo','Nutricional, antioxidante y energ�tico.').
cura('Eucalipto','Expectorante y antis�ptico.').
cura('Cebada','Nutricional y digestivo.').
cura('Tabachin','Antiinflamatorio y antiespasm�dico.').
cura('Borraja','Diur�tico y antiinflamatorio.').
cura('Cardo','Hepatoprotector y antioxidante.').
cura('Chicalote','Analg�sico y sedante.').
cura('Alcanfor','Antiinflamatorio y analg�sico.').
cura('Marrubio','Expectorante y digestivo.').
cura('Oregano','Antibacteriano y digestivo.').
cura('Lupulo','Sedante y digestivo.').
cura('Cuasia','Digestivo y antiparasitario.').
cura('Uva','Antioxidante y cardiovascular.').
cura('Cerezo','Antiinflamatorio y antioxidante.').
cura('Rosal','Antiinflamatorio y antioxidante.').
cura('Ortiga','Antiinflamatorio y diur�tico.').
cura('Espinosilla','Digestivo y antiinflamatorio.').
cura('Retama','Diur�tico y laxante.').
cura('Ajo','Antibacteriano y cardioprotector.').
cura('Cebolla','Antibacteriano y antioxidante.').
cura('Hiedra','Expectorante y antiespasm�dico.').
cura('Siempreviva','Antiinflamatorio y cicatrizante').
cura('Mastuerzo','Antibacteriano y expectorante.').
cura('Higuera','Laxante y digestivo.').
cura('Menta','Digestivo y antiespasm�dico.').
cura('Hinojo','Digestivo y carminativo.').
cura('Boldo','Digestivo y hepatoprotector.').
cura('Matarique','Antiinflamatorio y analg�sico.').
cura('Alpachaca','Digestivo y antiinflamatorio.').
cura('Granada','Antioxidante y antiinflamatorio.').
cura('Muicle','Antiinflamatorio y digestivo.').
cura('Monacillo','Antidiab�tico y digestivo.').
cura('Naranja','Antioxidante y digestivo.').
cura('Tamarindo','Laxante y digestivo.').
cura('Ipecacuana','Emetico (induce el v�mito) y expectorante.').
cura('Lavanda','Sedante, antis�ptico y antiinflamatorio.').
cura('Torillo','Antiinflamatorio y digestivo.').
cura('Alfalfa','Nutricional, digestivo y diur�tico.').
cura('Pino','Expectorante, antis�ptico y antiinflamatorio.').
cura('Belladona','Antiespasm�dico y analg�sico (uso \nrestringido por toxicidad)').
cura('Helecho','Antiinflamatorio y antihelm�ntico (uso \nrestringido por potencial toxicidad).').
cura('Acedera','Digestivo y antioxidante.').
cura('Azahar','Sedante, ansiol�tico y digestivo.').
cura('Ruibarbo','Laxante y digestivo.').
cura('Esparrago','Diur�tico y antioxidante.').
cura('Brionia','Laxante y expectorante (uso restringido por toxicidad).').
cura('Ruda','Antiespasm�dico, emenagogo y \nantiinflamatorio (uso restringido \npor potencial toxicidad).').
cura('Verbena','Digestivo, sedante y antiinflamatorio.').

%Origen de cada planta

origen('Abrojo','�reas Arenosas y pedregosas en regiones fr�as y templadas de M�xico').
origen('Acacia','Griego').
origen('Acanto','Griego').
origen('Aceitilla','Aparece en los sembrad�os en los meses de agosto a octubre.').
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
origen('Malva','Europa, norte de �frica y Asia.').
origen('Perejil','Regi�n mediterr�nea.').
origen('Limon','Asia.').
origen('Sauco','Europa y Am�rica del Norte.').
origen('Arnica','Europa y Siberia.').
origen('Llanten','Europa y Asia.').
origen('Fenogreco','Regi�n mediterr�nea y Asia occidental.').
origen('Zarzamora','Europa, Asia y Am�rica del Norte.').
origen('Tib','Regi�n del C�ucaso.').
origen('Valeriana','Europa y Asia.').
origen('Yerbabuena','Europa y Asia.').
origen('Quina roja','Andes de Am�rica del Sur.').
origen('Encino rojo','Am�rica del Norte.').
origen('Pimiento','Am�rica.').
origen('Hamamelis','Am�rica del Norte.').
origen('Toques','Am�rica Central y M�xico.').
origen('Ajenjo','Europa, Asia y norte de �frica.').
origen('Germen de trigo','Oriente Medio.').
origen('Eucalipto','Australia.').
origen('Cebada','Medio Oriente.').
origen('Tabachin','Madagascar.').
origen('Borraja','Regi�n mediterr�nea.').
origen('Cardo','Regi�n mediterr�nea.').
origen('Chicalote','M�xico y Am�rica Central.').
origen('Alcanfor','Asia.').
origen('Marrubio','Europa, norte de �frica y Asia.').
origen('Oregano','Regi�n mediterr�nea.').
origen('Lupulo','Europa y Asia occidental.').
origen('Cuasia','Am�rica del Sur y Central.').
origen('Uva','Regi�n mediterr�nea.').
origen('Cerezo','Europa y Asia occidental.').
origen('Rosal','Asia.').
origen('Ortiga','Europa, Asia y Am�rica del Norte.').
origen('Espinosilla','M�xico.').
origen('Retama','Regi�n mediterr�nea.').
origen('Ajo','Asia central.').
origen('Cebolla','Asia.').
origen('Hiedra','Europa y Asia.').
origen('Siempreviva','Europa.').
origen('Mastuerzo','Am�rica del Sur.').
origen('Higuera','Asia occidental.').
origen('Menta','Europa.').
origen('Hinojo','Regi�n mediterr�nea.').
origen('Boldo','Am�rica del Sur.').
origen('Matarique','M�xico.').
origen('Alpachaca','Am�rica del Norte.').
origen('Granada','Regi�n mediterr�nea y Asia.').
origen('Muicle','M�xico y Am�rica Central.').
origen('Monacillo','Am�rica.').
origen('Naranja','Asia.').
origen('Tamarindo','�frica tropical.').
origen('Ipecacuana','Am�rica del Sur.').
origen('Lavanda','Regi�n mediterr�nea.').
origen('Torillo','M�xico.').
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

uso('Abrojo','Cocer un poco la ra�z y \nservir en agua').
uso('Acacia','Una piza de polvo de la \nplanta revuelta de clara de huevo \nformando una cataplasma puesta sobre la quemadura').
uso('Acanto','para la picadura es directamente \nlas hojas pero si se hace un t� se combaten \nlas almorranas, ardores de orina, heridas por golpes, etc. \nsirve para desinflamar y curar los golpes').
uso('Aceitilla','En t�').
uso('Achicoria','Se cuecen las hojas secas \ny se come en ensalada o se pueden cocer las hojas \nverdes y se toma en t�').
uso('Aconito','Para el dolor de muelas se \nfrota la enc�a con el extracto y se introduce en las caries \nun algod�n empapado en ac�nito').
uso('Ahuehuete','T� de 3 a 4 veces al d�a').
uso('Anis','En t�').
uso('Berro','Se comen las hojas crudas').
uso('Canela','En t�').
uso('Cedron','En t� con las hojas frescas \no secadas a la sombra').
uso('Cola de caballo','T� con las hojas').
uso('Damiana','En t�').
uso('Diente de leon','Se utiliza toda la planta \npara hacer t�').
uso('Doradilla','Se usa toda la planta con todo \ny ra�z para hacer un t� que se toma despu�s \nde las comidas').
uso('Genciana','la ra�z se pone a remojar toda \nla noche y suelta su contenido para estimular el \napetito. tambi�n como se usa \nnormalmente es en un t�').
uso('Grama','Se toma como agua de uso').
uso('Linaza','Hacer una infusi�n que se toma en \ntraguitos durante todo el d�a').
uso('Manzanilla','En T�').
uso('Pinguica','Se usan hojas y fruto en t�').
uso('Romero','En t� normal, fumado para asma \ny en tinte al 10% para evitar la ca�da del pelo').
uso('Salvia','Masticada purifica el aliento y \nlimpia los dientes').
uso('Sanguinaria','Se usa como t� durante \n15 d�as').
uso('Sensitiva','Se cosen las hojas frescas y \nla ra�z para hacer un t�').
uso('Simonillo','Se utiliza toda la planta \npara hacer t�').
uso('Tronadora','En t�').
uso('Zarzaparrilla','Se usa la ra�z para \nhacer un t�').
uso('Malva','Infusi�n de las hojas y flores.').
uso('Perejil','Infusi�n de las hojas frescas o secas.').
uso('Limon','Jugo fresco o infusi�n de la c�scara.').
uso('Sauco','Infusi�n de las flores y bayas.').
uso('Arnica','Uso t�pico en forma de pomada o gel.').
uso('Llanten','Infusi�n de las hojas.').
uso('Fenogreco','Infusi�n de las semillas.').
uso('Zarzamora','Infusi�n de las hojas y consumo de los frutos.').
uso('Tib','Fermentaci�n de leche o agua azucarada con \nlos n�dulos de kefir.').
uso('Valeriana','Infusi�n de la ra�z.').
uso('Yerbabuena','Infusi�n de las hojas.').
uso('Quina roja','Infusi�n de la corteza.').
uso('Encino rojo','Decocci�n de la corteza.').
uso('Pimiento','Infusi�n de los frutos secos.').
uso('Hamamelis','Infusi�n de las hojas y corteza.').
uso('Toques','Infusi�n de las hojas y flores.').
uso('Ajenjo','Infusi�n de las hojas.').
uso('Germen de trigo','Consumo directo en alimentos o bebidas.').
uso('Eucalipto','Infusi�n de las hojas.').
uso('Cebada','Infusi�n de los granos o germen.').
uso('Tabachin','Infusi�n de las flores y hojas.').
uso('Borraja','Infusi�n de las hojas y flores.').
uso('Cardo','Infusi�n de las semillas.').
uso('Chicalote','Infusi�n de las hojas y flores.').
uso('Alcanfor','Uso t�pico en pomadas y ung�entos.').
uso('Marrubio','Infusi�n de las hojas y flores.').
uso('Oregano','Infusi�n de las hojas y flores.').
uso('Lupulo','Infusi�n de las flores (conos).').
uso('Cuasia','Infusi�n de la corteza.').
uso('Uva','Consumo directo del fruto o jugo.').
uso('Cerezo','Infusi�n de los ped�nculos o consumo directo del fruto.').
uso('Rosal','Infusi�n de los p�talos y caderas (frutos).').
uso('Ortiga','Infusi�n de las hojas.').
uso('Espinosilla','Infusi�n de las hojas y flores.').
uso('Retama','Infusi�n de las flores.').
uso('Ajo','Consumo crudo o en infusi�n.').
uso('Cebolla','Consumo crudo o en infusi�n.').
uso('Hiedra','Infusi�n de las hojas.').
uso('Siempreviva','Uso t�pico de las hojas trituradas').
uso('Mastuerzo','Infusi�n de las hojas y flores.').
uso('Higuera','Consumo del fruto o infusi�n de las hojas.').
uso('Menta','Infusi�n de las hojas.').
uso('Hinojo','Infusi�n de las semillas.').
uso('Boldo','Infusi�n de las hojas.').
uso('Matarique','Infusi�n de las ra�ces.').
uso('Alpachaca','Infusi�n de las hojas.').
uso('Granada','Consumo del fruto o infusi�n de la c�scara.').
uso('Muicle','Infusi�n de las hojas y flores.').
uso('Monacillo','Infusi�n de las hojas y flores.').
uso('Naranja','Consumo del fruto o infusi�n de la c�scara.').
uso('Tamarindo','Consumo del fruto o infusi�n.').
uso('Ipecacuana','Infusi�n de la ra�z seca').
uso('Lavanda','Infusi�n de las flores secas').
uso('Torillo','Infusi�n de las hojas y ra�ces.').
uso('Alfalfa','Infusi�n de las hojas y brotes frescos o secos').
uso('Pino','Infusi�n de las agujas o resina en agua caliente.').
uso('Belladona','Uso muy controlado bajo supervisi�n\n m�dica; normalmente se utiliza en forma de extracto.').
uso('Helecho','Infusi�n de las hojas (bajo supervisi�n m�dica).').
uso('Acedera','Infusi�n de las hojas frescas o secas.').
uso('Azahar','Infusi�n de las flores frescas o secas.').
uso('Ruibarbo','Infusi�n de los tallos (las hojas son t�xicas).').
uso('Esparrago','Consumo del brote fresco o infusi�n de los brotes.').
uso('Brionia','Uso muy controlado bajo supervisi�n\n m�dica; normalmente se utiliza \nen forma de extracto.').
uso('Ruda','Infusi�n de las hojas (bajo supervisi�n m�dica).').
uso('Verbena','Infusi�n de las hojas y flores frescas o secas.').

%Enfermedades y Plantas que ayudan

enfermedad('Abcesos','Malva').
enfermedad('Abceso hepatico','Zarzaparrilla').
enfermedad('Acidez estomacal','Anis, Perejil').
enfermedad('Acido urico','Sanguinaria, Lim�n, Sauco').
enfermedad('Acne','�rnica').
enfermedad('Aftas','Llant�n, Fenogreco, Zarzamora').
enfermedad('Agotamiento','Salvia, Tib, Valeriana').
enfermedad('Agruras','Yerbabuena, Manzanilla, Jugo de lim�n o toronja').
enfermedad('Albuminaria','Ping�ica, Quina roja, Encino rojo').
enfermedad('Alcoholismo','Pimiento').
enfermedad('Almorranas','Salvia, Hamamelis, Sanguinaria, \nCola de caballo, �rnica, Toques, Sauco').
enfermedad('Anemia','Ajenjo, Germen de trigo, Quina,\n Canela, Alholva').
enfermedad('Anginas','Eucalipto, Cebada, Salvia, Tabach�n, Borraja').
enfermedad('Anorexia','Ajenjo, Genciana, Yerbabuena').
enfermedad('Arterosclerosis','Lim�n, Genciana, Cardo, Zarzaparrilla').
enfermedad('Artritis','�rnica, Chicalote, Alcanfor, Toronja').
enfermedad('Asma','Eucalipto, Marrubio, Toloache, \nOr�gano, Salvia').
enfermedad('Atonia estomacal','L�pulo, Eucalipto, Cuasia').
enfermedad('Bazo','Uva, Cerezo').
enfermedad('Inflamacion de boca','Malva, Rosal, Lim�n, Salvia').
enfermedad('Estomatitis','Rosal, Encina, Salvia, Zarzamora').
enfermedad('Perdida de cabello','Ortiga, Espinosilla, Marrubio, Romero').
enfermedad('Calambres','An�s, Tila, Manzanilla, Ajenjo').
enfermedad('Calculos biliares','Diente de le�n, Aceite de oliva, Retama').
enfermedad('Calculos renales','Cabellos de elote, Ping�ica, Cola de caballo').
enfermedad('Callos','Ajo, Cebolla').
enfermedad('Caries','Hiedra, Cola de caballo').
enfermedad('Caspa','Ortiga, Lim�n, Romero').
enfermedad('Cancer de utero','Cachalote, Llant�n, Siempreviva').
enfermedad('Ciatica','Mastuerzo, Higuera, Sauco').
enfermedad('Circulacion','Toronjil, Sanguinaria, Salvia, Hamamelis').
enfermedad('Cistitis','Cola de caballo, Doradilla, Ajo, Cabellos de elote').
enfermedad('Colicos','Menta, Hinojo, Manzanilla, Toronjil, Boldo').
enfermedad('Colitis','Linaza, An�s, Romero, Cola de caballo').
enfermedad('Contusiones','�rnica, Hamamelis, Laurel, Brionia').
enfermedad('Corazon','Salvia, Nuez de kola, Tejocote').
enfermedad('Diabetes','Matarique, Tronadora, Eucalipto, Damiana').
enfermedad('Diarrea cronica','Capul�n, Corteza de mezquite, Tlachicholes').
enfermedad('Diarrea por irritacion','Linaza, Membrillo, Arroz, Cebada').
enfermedad('Diarrea por inflamacion','Guayaba, Alpachaca, Granada').
enfermedad('Diarrea Verdosa','Manzanilla, Simonillo, Capullo de siempreviva').
enfermedad('Diarrea con sangre','Chaparro amargoso, Muicle, Monacillo').
enfermedad('Difteria','Lim�n, Naranja').
enfermedad('Disenteria','Tamarindo, Chaparro amargoso, Ipecacuana, Cedr�n').
enfermedad('Dispepsia','An�s, Menta, Yerbabuena, T� de lim�n').
enfermedad('Dolores musculares','Alcanfor').
enfermedad('Empacho','Tamarindo').
enfermedad('Enteritis','Linaza, Cedr�n, Llant�n').
enfermedad('Epilepsia','Valeriana').
enfermedad('Epistaxis','Hierba del pollo, Cebolla, Perejil').
enfermedad('Erisipela','Sauco, Hiedra, Zanahoria').
enfermedad('Escarlatina','Borraja, Sauco, Cebolla').
enfermedad('Escorbuto','Aso, Lim�n, Berro, Cebolla, Geranio').
enfermedad('Estre�imiento','Ciruela, Linaza, Ch�a, Tamarindo, Agar-agar').
enfermedad('Faringitis','Eucalipto, Lavanda, Anacahuite').
enfermedad('Flatulencias','Apo, Torillo, Perejil, \nAn�s estrella, Hinojo, Toronjil, \nRomero, Ruibarbo, Ruda, Menta').
enfermedad('Flebitis','�rnica, Alfalfa, Lino, Malvavisco, Romero, Quina').
enfermedad('Flemas','Genciana, Or�gano').
enfermedad('Forunculos','Fenogreco, Malvavisco, Hiedra').
enfermedad('Gastralgia','Manzanilla, An�s estrella').
enfermedad('Gonorrea','Cola de caballo, Doradilla, Zarzaparrilla').
enfermedad('Gota','Apio, Cerezo, Lim�n, Pino,\n Alcanfor, Ac�nito, Belladona, Bele�o, \nC�lchico, Chicalote').
enfermedad('Gripe','Eucalipto, Lim�n, Quina, Zarzaparrilla, \nCal�ndula').
enfermedad('Halitosis','Hinojo, Menta').
enfermedad('Hemorragia interna','Mastuerzo, Ortiga, Rosal').
enfermedad('Hepatitis','Retama, Boldo, Alcachofa, Prodigiosa, C�scara sagrada').
enfermedad('Hernia','Helecho, Ricino, Tabaco').
enfermedad('Herpes','Linaza, Llant�n').
enfermedad('Heridas','�rnica, Hamamelis').
enfermedad('Hidropesia','Alcachofa, Cardo, Perejil, Sauco, Berro, Retama').
enfermedad('Congestion de higado','Marrubio, Boldo, Doradilla, Ruibarbo').
enfermedad('Hipertension','Esp�rrago, Alpiste, Mu�rdago').
enfermedad('Hipotension','Miel, Nuez de kola, Acedera').
enfermedad('Hipo','An�s, Hinojo, Tila, Valeriana').
enfermedad('Histerismo','Azahar, Bele�o, Tila, Valeriana').
enfermedad('Insomnio','Pasiflora, Azahar, Menta, Manzanilla,\n Lechuga, Tila').
enfermedad('Intestino','Genciana, Melisa').
enfermedad('Impotencia sexual','Yohimbo, Nuez v�mica, Aguacate').
enfermedad('Jaqueca','Manzanilla, Ac�nito, Valeriana,\n Tila, Chicalote').
enfermedad('Lactancia','Hinojo, An�s, Menta, Perejil, Zanahoria').
enfermedad('Laringitis','Ac�nito, Borraja, Cebolla rosa, \nBenju�, Encino').
enfermedad('Leucorrea','Encina, Zarzaparrilla, Pino, Enebro, Genciana').
enfermedad('Lombrices','Ajenjo, Ajo, Brionia, Aguacate, Papaya').
enfermedad('Lumbago','Avena, Cebada, Tomillo, Verbena, Epazote').
enfermedad('Llagas','Fenogreco, Eucalipto, Llant�n, Sanguinaria').
enfermedad('Malaria','Quina, Girasol, Eucalipto').
enfermedad('Menopausia','Azahar, Hamamelis, Tila, Quina roja').
enfermedad('Menstruacion abundante','Azafr�n, Hamamelis').
enfermedad('Menstruacion dolorosa','Belladona, An�s estrella').
enfermedad('Menstruacion escasa','Ruda, Ajenjo, Manzanilla').
enfermedad('Menstruacion irregular','Apo, Hisopo, Quina \namarilla, Sabina, Artemisa').
enfermedad('Muelas','Clavo, Hiedra').
enfermedad('Hemorragia Nasal','Ortiga, Cola de caballo, Ruda, Eucalipto').
enfermedad('Nauseas','An�s, Ajenjo, Menta, Salvia').
enfermedad('Neuralgias','Manzanilla, Menta, Valeriana, Boldo').
enfermedad('Neurastenia','Pasiflora, T� negro, Mate, Valeriana').
enfermedad('Nefritis','Linaza, Grama, Cebada, Llant�n,\n Doradilla, Esp�rrago, Ruda').
enfermedad('Obesidad','Toronjil, Marrubio, Lim�n, Malva, Esp�rrago').
enfermedad('Oidos','Boldo, Aceite de oliva, Llant�n, Hiedra').
enfermedad('Conjuntivitis e irritacion','Manzanilla, Lim�n, Llant�n,\n Salvia, Ruda, Rosal').
enfermedad('Pies olorosos','Laurel, Encina').
enfermedad('Piquetes de abeja','Miel, Perejil, Cebolla, Puerco').
enfermedad('Piquetes de ara�a','Fresno, Ipecacuana').
enfermedad('Piquetes de mosco','Alcanfor, Perejil, Hamamelis').
enfermedad('Pulmonia','Eucalipto, Ocote, Gordolobo, Borraja, Sauco').
enfermedad('Quemaduras','Linaza, Cebolla, Hiedra').
enfermedad('Raquitismo','Nogal').
enfermedad('Reumatismo','Ajo, Apio, Borraja, Gobernadora, \nPino, Romero, Sanguinaria, Marrubio, Tabaco').
enfermedad('Ri�ones','Cabellos de elote, Cola de caballo, Apio').
enfermedad('Ronquera','Eucalipto, Pino, Gordolobo').
enfermedad('Saba�ones','Ajo, Cebolla').
enfermedad('Sarampion','Borraja, Ortiga, Sauco').
enfermedad('Sarna','Ajo, Alcanfor, Menta, Tomillo, Romero').
enfermedad('Sarpullido','Encina, Salvia, Tila').
enfermedad('Sed','Lim�n, Tamarindo, Pirul').
enfermedad('Solitaria','Semilla de calabaza, Gramado, Coquito\n de aceite, Helecho macho').
enfermedad('Sudoracion excesiva','Encina').
enfermedad('Tifoidea','Alcanfor, Borraja, Quina, Canela, Romero, Salvia').
enfermedad('Tina','Berro, Tila, Tamarindo, Salvia').
enfermedad('Tos','Eucalipto, Capul�n, Cedr�n, Salvia, \nMalva, Marrubio').
enfermedad('Tos Ferina','Gelsemio, Quina, R�bano, Violeta').
enfermedad('Tuberculosis','Mastuerzo, Berro, Ajo, Eucalipto,\n Pirul, Pino, Roble').
enfermedad('Ulcera','Cuachalalate, Sanguinaria, Cola de caballo, Girasol').
enfermedad('Urticaria','Lim�n, Ruibarbo').
enfermedad('Varices','Hamamelis, Casta�o de Indias, Llant�n,\n Toronjil').
enfermedad('Vejiga','Apio, Cipr�s, Cola de caballo, Ortiga, Malva').
enfermedad('Verrugas','Leche de higuera, Cebolla, Nogal').
enfermedad('Vertigos','Albahaca, Espino').
enfermedad('Vomitos','Menta, Tila, Marrubio, Valeriana, Salvia').
enfermedad('Carencia de vitaminas','Alfalfa, Espinacas, Acelga,\n Berro, Cebolla, Lim�n, Zanahoria').

%Medicamento que se produce con plantas
medicamento('Digital','Digitalina').
medicamento('Ipeca','Emetina').
medicamento('Mez Vomica','Estricnina').
medicamento('Eleboro Banco','Veratrina').
medicamento('Colchico','Colquicina').
medicamento('Belladona','Atropina').
medicamento('Quina','Quinina').
medicamento('Cacao','Teobromina').
medicamento('Retama','Esparte�na').
medicamento('Coca','Coca�na').
medicamento('Peyote','Mescalina').
medicamento('Efedra','Efedrina').
medicamento('Barbasco','Hormonas').
medicamento('Nen�far Amarillo','Lutenurina').
medicamento('�ame','Diosponina').
medicamento('Artemisa','Tavremisina').
medicamento('Semilla de Yute','Olitorisida').
medicamento('Toloache','�cido lis�rgico').
medicamento('Eucalipto','Eucaliptol').
medicamento('Rosal','Quercitrina').
medicamento('Acido lisergico','LCD').





































