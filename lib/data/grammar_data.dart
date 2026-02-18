import 'package:eurolingo/models/grammar_model.dart';

final List<GrammarTopic> b1GrammarTopics = [
  GrammarTopic(
    id: 'b1_1',
    level: 'B1',
    title: 'Present Perfect vs. Past Simple',
    explanation:
        'Geçmişte belirsiz bir zamanda yapılan (Present Perfect) ile zamanı belli olan (Past Simple) eylemler arasındaki farktır.\n\n• Present Perfect: I have seen that movie. (Zaman önemli değil, izlemiş olmam önemli.)\n• Past Simple: I saw that movie yesterday. (Zaman belli: dün.)',
    examples: [
      GrammarExample(
        en: 'I have visited London twice.',
        tr: 'Londra\'yı iki kez ziyaret ettim.',
      ),
      GrammarExample(
        en: 'I visited London in 2022.',
        tr: 'Londra\'yı 2022\'de ziyaret ettim.',
      ),
      GrammarExample(
        en: 'She has already finished her homework.',
        tr: 'Ödevini çoktan bitirdi.',
      ),
      GrammarExample(
        en: 'They moved to this city five years ago.',
        tr: 'Beş yıl önce bu şehre taşındılar.',
      ),
      GrammarExample(
        en: 'Have you ever eaten sushi?',
        tr: 'Hiç suşi yedin mi?',
      ),
      GrammarExample(
        en: 'I lost my keys last night.',
        tr: 'Dün gece anahtarlarımı kaybettim.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question:
            'I ________ London twice this year, but I ________ there in 2022.',
        options: [
          'visited / have been',
          'have visited / went',
          'went / have visited',
        ],
        correctIndex: 1,
        explanation:
            'Bu yıl içindeki belirsiz sayıdaki ziyaret için "have visited", 2022 gibi belirli bir zaman için "went" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'She ________ her keys. She can\'t find them anywhere.',
        options: ['lost', 'has lost', 'was losing'],
        correctIndex: 1,
        explanation:
            'Eylemin sonucu şu anı etkiliyorsa (anahtarlar yoksa) Present Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ that movie three times already.',
        options: ['saw', 'have seen', 'was seeing'],
        correctIndex: 1,
        explanation:
            'Deneyimlerden bahsederken "already" ile Present Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'They ________ to Paris last summer.',
        options: ['have gone', 'went', 'were going'],
        correctIndex: 1,
        explanation:
            '"Last summer" gibi belirli bir geçmiş zaman ifadesi Past Simple gerektirir.',
      ),
      GrammarQuizQuestion(
        question: 'My brother ________ a new job two days ago.',
        options: ['has started', 'started', 'is starting'],
        correctIndex: 1,
        explanation:
            '"Two days ago" ifadesi eylemin bittiği net zamanı gösterir.',
      ),
      GrammarQuizQuestion(
        question: '________ you ever ________ a celebrity?',
        options: ['Did / meet', 'Have / met', 'Were / meeting'],
        correctIndex: 1,
        explanation:
            'Hayat boyu süren deneyimler için "Have you ever...?" kalıbı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ my homework yet. Can I do it later?',
        options: ['haven\'t finished', 'didn\'t finish', 'not finished'],
        correctIndex: 0,
        explanation:
            '"Yet" genellikle Present Perfect ile kullanılır ve eylemin henüz tamamlanmadığını belirtir.',
      ),
      GrammarQuizQuestion(
        question: 'We ________ this car since 2015.',
        options: ['have had', 'had', 'are having'],
        correctIndex: 0,
        explanation:
            '"Since" ile başlayan süreçlerde Present Perfect (have + V3) yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'How many countries ________ you ________ so far?',
        options: ['did / visit', 'have / visited', 'were / visiting'],
        correctIndex: 1,
        explanation:
            '"So far" (şu ana kadar) ifadesi Present Perfect gerektirir.',
      ),
      GrammarQuizQuestion(
        question: 'It ________ raining ten minutes ago.',
        options: ['has stopped', 'stopped', 'is stopping'],
        correctIndex: 1,
        explanation:
            '"Ten minutes ago" eylemin bittiği net anı belirttiği için Past Simple kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'They ________ in this neighborhood for twenty years.',
        options: ['lived', 'have lived', 'are living'],
        correctIndex: 1,
        explanation:
            'Hala devam eden veya etkisi süren durumlar için Present Perfect (have lived) uygundur.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ a ghost when I ________ a child.',
        options: ['have seen / was', 'saw / was', 'saw / have been'],
        correctIndex: 1,
        explanation:
            'Çocukluk dönemi bittiği için her iki eylem de Past Simple ile anlatılır.',
      ),
      GrammarQuizQuestion(
        question: 'Sarah ________ just ________ from her vacation.',
        options: ['has / returned', 'did / return', 'is / returning'],
        correctIndex: 0,
        explanation:
            '"Just" (henüz/şimdi) zarfı eylemin yeni bittiğini gösterir ve Present Perfect ile kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'We ________ at that Italian restaurant last night.',
        options: ['have eaten', 'ate', 'were eating'],
        correctIndex: 1,
        explanation:
            '"Last night" ifadesi nedeniyle Past Simple tercih edilmelidir.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ never ________ to Japan, but I want to go.',
        options: ['have / been', 'did / go', 'was / being'],
        correctIndex: 0,
        explanation:
            'Hayattaki deneyimlerden bahsederken "have been" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'They ________ that house for ages.',
        options: ['owned', 'have owned', 'are owning'],
        correctIndex: 1,
        explanation:
            'Süreklilik arz eden sahiplik durumlarında Present Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'She ________ in London for six months in 2010.',
        options: ['lived', 'has lived', 'lives'],
        correctIndex: 0,
        explanation:
            'Geçmişte bitmiş ve belirli bir zaman aralığı (2010) olan eylemler Past Simple ile anlatılır.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b1_2',
    level: 'B1',
    title: 'Second Conditional',
    explanation:
        'Şu an için gerçek olmayan veya gerçekleşme ihtimali düşük olan hayali durumlar için kullanılır.\n\nFormül: If + Past Simple, ... would + Verb',
    examples: [
      GrammarExample(
        en: 'If I won the lottery, I would buy a private jet.',
        tr: 'Piyangoyu kazansaydım, özel jet alırdım.',
      ),
      GrammarExample(
        en: 'If I were you, I wouldn\'t go there.',
        tr: 'Senin yerinde olsam, oraya gitmezdim.',
      ),
      GrammarExample(
        en: 'She would travel more if she had more money.',
        tr: 'Daha çok parası olsaydı daha fazla seyahat ederdi.',
      ),
      GrammarExample(
        en: 'If it stopped raining, we could go for a walk.',
        tr: 'Yağmur dursa yürüyüşe çıkabilirdik.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question:
            'If I ________ more time, I ________ learn how to play the piano.',
        options: ['have / will', 'had / would', 'had / will'],
        correctIndex: 1,
        explanation:
            'Second Conditional yapısında If cümlesinde Past Simple, ana cümlede would kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'If she ________ the president, she ________ change the laws.',
        options: ['is / will', 'was / would', 'were / would'],
        correctIndex: 2,
        explanation:
            'Second Conditional\'da "be" fiili tüm özneler için "were" olarak tercih edilir (hayali durum).',
      ),
      GrammarQuizQuestion(
        question: 'I ________ help you if I ________ how to fix this.',
        options: ['would / know', 'will / knew', 'would / knew'],
        correctIndex: 2,
        explanation:
            'Ana cümlede "would", If kısmında "knew" (Past Simple) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'If they ________ more, they ________ the match.',
        options: [
          'practiced / would win',
          'practice / will win',
          'practiced / win',
        ],
        correctIndex: 0,
        explanation:
            'Şu anki durumun tersi hayal ediliyor, Past Simple + would yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'What ________ you ________ if you saw a ghost?',
        options: ['will / do', 'would / do', 'did / do'],
        correctIndex: 1,
        explanation:
            'Hayali/mümkün olmayan bir durum sorulduğu için "would do" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'If I ________ a car, I ________ to work every day.',
        options: ['have / will drive', 'had / would drive', 'had / will drive'],
        correctIndex: 1,
        explanation: 'Second Conditional: If + Past, ... would + V1.',
      ),
      GrammarQuizQuestion(
        question: 'If she ________ younger, she ________ travel the world.',
        options: ['is / will', 'was / would', 'were / would'],
        correctIndex: 2,
        explanation:
            'Hayali durumlarda (Second Conditional) "be" fiili "were" olur.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ so tired if I ________ a better job.',
        options: ['won\'t be / have', 'wouldn\'t be / had', 'am not / had'],
        correctIndex: 1,
        explanation:
            'Second Conditional: Would(n\'t) + V1 ... if + Past Simple.',
      ),
      GrammarQuizQuestion(
        question: 'If it ________ tonight, we ________ stay at home.',
        options: ['snows / will', 'snowed / would', 'snowed / will'],
        correctIndex: 1,
        explanation:
            'Düşük ihtimal veya hayal kurma durumunda Second Conditional (snowed / would) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'If you ________ a million dollars, what ________ you buy?',
        options: ['have / will', 'had / would', 'had / do'],
        correctIndex: 1,
        explanation:
            'Büyük ödül kazanma gibi düşük ihtimalleri hayal ederken Second Conditional yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'If I ________ how to speak Japanese, I ________ move to Tokyo.',
        options: ['know / will', 'knew / would', 'knew / will'],
        correctIndex: 1,
        explanation:
            'Şu an bilinmeyen bir yetenek hayal edildiği için Past Simple + would kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Where ________ you live if you ________ choose any city?',
        options: ['will / could', 'would / could', 'can / did'],
        correctIndex: 1,
        explanation: 'İmkan ve hayal bir arada: would + could (past of can).',
      ),
      GrammarQuizQuestion(
        question: 'If you ________ a movie star, who ________ you want to be?',
        options: ['are / will', 'were / would', 'was / did'],
        correctIndex: 1,
        explanation:
            'Şu an gerçek olmayan bir durum hayal edildiği için Second Conditional kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'She ________ much happier if she ________ in the countryside.',
        options: ['will be / lives', 'would be / lived', 'is / lived'],
        correctIndex: 1,
        explanation:
            'Hayali durum (Second Conditional): would + V1 ... if + Past Simple.',
      ),
      GrammarQuizQuestion(
        question: 'If I ________ you, I ________ buy those shoes.',
        options: ['was / wouldn\'t', 'were / wouldn\'t', 'am / won\'t'],
        correctIndex: 1,
        explanation: 'Tavsiye verirken "If I were you..." kalıbı kullanılır.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b1_3',
    level: 'B1',
    title: 'Passive Voice (Edilgen Yapı)',
    explanation:
        'Eylemi kimin yaptığından ziyade, eylemin kendisinin veya eylemden etkilenen nesnenin önemli olduğu durumlarda kullanılır.',
    examples: [
      GrammarExample(
        en: 'This app is used by millions.',
        tr: 'Bu uygulama milyonlarca kişi tarafından kullanılıyor.',
        note: 'Present Passive',
      ),
      GrammarExample(
        en: 'The telephone was invented by Bell.',
        tr: 'Telefon Bell tarafından icat edildi.',
        note: 'Past Passive',
      ),
      GrammarExample(
        en: 'Dinner is served at 7 PM.',
        tr: 'Akşam yemeği akşam 7\'de servis edilir.',
      ),
      GrammarExample(
        en: 'The pyramids were built thousands of years ago.',
        tr: 'Piramitler binlerce yıl önce inşa edildi.',
      ),
      GrammarExample(
        en: 'Coffee is grown in Brazil.',
        tr: 'Brezilya\'da kahve yetiştirilir.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'Change to Passive: "The chef prepares the meal."',
        options: [
          'The meal is prepared by the chef.',
          'The meal was prepared by the chef.',
          'The meal is preparing by the chef.',
        ],
        correctIndex: 0,
        explanation:
            'Present Simple cümleler "am/is/are + V3" yapısıyla pasif yapılır.',
      ),
      GrammarQuizQuestion(
        question: 'Many songs ________ by this band last year.',
        options: ['were recorded', 'was recorded', 'are recorded'],
        correctIndex: 0,
        explanation:
            'Geçmiş zaman (last year) ve çoğul nesne (songs) için "were + V3" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The Mona Lisa ________ by Leonardo da Vinci.',
        options: ['is painted', 'was painted', 'has painted'],
        correctIndex: 1,
        explanation:
            'Geçmişte bitmiş belirli bir eylem için Past Passive (was + V3) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Letters ________ every morning at 8:00.',
        options: ['are delivered', 'is delivered', 'delivered'],
        correctIndex: 0,
        explanation:
            'Rutin bir eylem için Present Passive (are + V3) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'This house ________ by my grandfather in 1960.',
        options: ['is built', 'was built', 'built'],
        correctIndex: 1,
        explanation: 'Geçmişteki inşa eylemi için "was built" yapısı doğrudur.',
      ),
      GrammarQuizQuestion(
        question: 'English ________ all over the world.',
        options: ['speaks', 'is spoken', 'is speak'],
        correctIndex: 1,
        explanation: 'Genel bir durumdan bahsederken "is spoken" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'A lot of tea ________ in Turkey.',
        options: ['is drunk', 'is drink', 'are drunk'],
        correctIndex: 0,
        explanation:
            'Tea sayılamayan bir isim olduğu için tekil yardımcı fiil (is) ve V3 hali (drunk) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The bridge ________ by the end of next year.',
        options: ['will be finished', 'was finished', 'is finished'],
        correctIndex: 0,
        explanation:
            'Gelecek zaman belirteci olduğu için Future Passive (will be + V3) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Thousands of new cars ________ every day.',
        options: ['are made', 'is made', 'was made'],
        correctIndex: 0,
        explanation:
            'Çoğul özne (cars) ve geniş zaman eylemi olduğu için "are made" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The criminal ________ by the police yesterday afternoon.',
        options: ['has caught', 'was caught', 'is caught'],
        correctIndex: 1,
        explanation:
            'Dün gerçekleşen bir olay Past Passive (was + V3) ile anlatılır.',
      ),
      GrammarQuizQuestion(
        question: 'This book ________ into twenty different languages.',
        options: ['has been translated', 'translated', 'is translate'],
        correctIndex: 0,
        explanation:
            'Eylem tamamlanmış ama etkisi sürüyorsa/zamanı mühim değilse Present Perfect Passive (has been + V3) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'When ________ this castle ________?',
        options: ['is / built', 'was / built', 'did / built'],
        correctIndex: 1,
        explanation:
            'Geçmişteki bir yapının inşa zamanı sorulurken Past Passive soru formu kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Our house ________ every five years.',
        options: ['is painted', 'was painted', 'paints'],
        correctIndex: 0,
        explanation:
            'Düzenli aralıklarla yapılan rutin pasif eylemler için Present Passive kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The meeting ________ because of the weather.',
        options: ['canceled', 'was canceled', 'is cancel'],
        correctIndex: 1,
        explanation: 'Tamamlanmış bir iptal eylemi Past Passive ile anlatılır.',
      ),
      GrammarQuizQuestion(
        question: 'These files ________ to the server yesterday.',
        options: ['uploaded', 'were uploaded', 'are uploaded'],
        correctIndex: 1,
        explanation:
            '"Yesterday" ve çoğul nesne için "were uploaded" kullanılır.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b1_4',
    level: 'B1',
    title: 'Relative Clauses',
    explanation:
        'İsimleri daha detaylı tanımlamak için kullanılır. Who (insanlar), Which (cansızlar), Where (yerler) gibi kelimelerle iki cümle bağlanır.',
    examples: [
      GrammarExample(
        en: 'This is the hotel where we stayed last summer.',
        tr: 'Bu, geçen yaz kaldığımız otel.',
      ),
      GrammarExample(
        en: 'I met a girl who speaks five languages.',
        tr: 'Beş dil konuşan bir kızla tanıştım.',
      ),
      GrammarExample(
        en: 'The book which you lent me is great.',
        tr: 'Bana ödünç verdiğin kitap harika.',
      ),
      GrammarExample(
        en: 'He is the man who won the race.',
        tr: 'O, yarışı kazanan adam.',
      ),
      GrammarExample(
        en: 'I visited the house where I was born.',
        tr: 'Doğduğum evi ziyaret ettim.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'That is the man ________ car was stolen yesterday.',
        options: ['who', 'which', 'whose'],
        correctIndex: 2,
        explanation:
            'Aitlik belirtmek için (adamın arabası) "whose" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I don\'t like movies ________ are too violent.',
        options: ['who', 'which', 'where'],
        correctIndex: 1,
        explanation:
            'Cansız varlıklar (movies) için "which" veya "that" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The student ________ sits next to me is very clever.',
        options: ['who', 'which', 'where'],
        correctIndex: 0,
        explanation:
            'İnsanlar (student) söz konusu olduğunda "who" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'This is the hospital ________ I was born.',
        options: ['who', 'which', 'where'],
        correctIndex: 2,
        explanation: 'Yerler için "where" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I have a friend ________ father is a famous actor.',
        options: ['who', 'which', 'whose'],
        correctIndex: 2,
        explanation:
            'Birisinin babasından bahsederken aitlik belirten "whose" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The car ________ I bought yesterday is red.',
        options: ['who', 'which', 'where'],
        correctIndex: 1,
        explanation: 'Cansız nesneler için "which" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The people ________ live next door are very friendly.',
        options: ['who', 'which', 'whose'],
        correctIndex: 0,
        explanation: 'İnsanları tanımlarken "who" (veya "that") kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'This is the book ________ I was telling you about.',
        options: ['who', 'which', 'where'],
        correctIndex: 1,
        explanation: 'Cansız bir nesne (book) için "which" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Summer is the season ________ most people go on holiday.',
        options: ['when', 'where', 'which'],
        correctIndex: 0,
        explanation:
            'Zaman belirten ifadeleri (season) nitelemek için "when" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I love the restaurant ________ we had our first date.',
        options: ['when', 'where', 'who'],
        correctIndex: 1,
        explanation: 'Mekanları nitelemek için "where" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The scientist ________ won the Nobel Prize is my uncle.',
        options: ['which', 'who', 'whose'],
        correctIndex: 1,
        explanation:
            'Kişileri tanımlayan bir relative clause olduğu için "who" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Is this the umbrella ________ you lost?',
        options: ['where', 'which', 'whose'],
        correctIndex: 1,
        explanation: 'Cansız nesne (umbrella) için "which" uygundur.',
      ),
      GrammarQuizQuestion(
        question: 'The town ________ I grew up is very small.',
        options: ['which', 'where', 'when'],
        correctIndex: 1,
        explanation: 'Yerler için "where" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'That\'s the woman ________ husband is a pilot.',
        options: ['who', 'whose', 'which'],
        correctIndex: 1,
        explanation: '"Kimin kocası" (aitlik) için "whose" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The shoes ________ I bought are too tight.',
        options: ['who', 'which', 'where'],
        correctIndex: 1,
        explanation: 'Cansız nesneler için "which" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: '1990 was the year ________ they got married.',
        options: ['where', 'when', 'which'],
        correctIndex: 1,
        explanation: 'Zamanlar için "when" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'He is the teacher ________ helped me with my essay.',
        options: ['who', 'which', 'where'],
        correctIndex: 0,
        explanation: 'İnsanlar için "who" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The car ________ engine is broken belongs to my neighbor.',
        options: ['who', 'which', 'whose'],
        correctIndex: 2,
        explanation: '"Arabanın motoru" (aitlik) için "whose" kullanılır.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b1_5',
    level: 'B1',
    title: 'Modal Verbs of Probability',
    explanation:
        'Bir şeyun doğruluğu hakkında tahmin yürütürken kullanılır.\n\n• Must: (Güçlü ihtimal/Eminim)\n• Might/Could: (Zayıf ihtimal)\n• Can\'t: (İmkansız/Eminim)',
    examples: [
      GrammarExample(en: 'He must be at home.', tr: 'Evde olmalı. (Eminim)'),
      GrammarExample(en: 'It might rain today.', tr: 'Bugün yağmur yağabilir.'),
      GrammarExample(
        en: 'She can\'t be hungry; she just ate.',
        tr: 'Aç olamaz; daha yeni yemek yedi.',
      ),
      GrammarExample(en: 'They could be lost.', tr: 'Kaybolmuş olabilirler.'),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'He has a very expensive car. He ________ be rich.',
        options: ['must', 'can\'t', 'might'],
        correctIndex: 0,
        explanation: 'Güçlü bir çıkarım/tahmin var: "Zengin olmalı."',
      ),
      GrammarQuizQuestion(
        question:
            'She ________ be at the office. I saw her at the cafe 5 minutes ago.',
        options: ['must', 'can\'t', 'might'],
        correctIndex: 1,
        explanation:
            'İmkansızlık belirtmek için "can\'t" kullanılır (5 dakika önce kafedeymiş).',
      ),
      GrammarQuizQuestion(
        question: 'It\'s cloudy. It ________ rain later.',
        options: ['must', 'can\'t', 'might'],
        correctIndex: 2,
        explanation: 'Düşük/Orta ihtimal durumunda "might" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Vera ________ know the secret, but I\'m not sure.',
        options: ['must', 'could', 'can\'t'],
        correctIndex: 1,
        explanation: 'Emin olunmayan durumlarda "could" (ihtimal) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'You haven\'t eaten all day. You ________ be exhausted.',
        options: ['must', 'can\'t', 'might'],
        correctIndex: 0,
        explanation:
            'Tüm gün yemek yemeyen birinin yorgun olması güçlü bir tahmindir.',
      ),
      GrammarQuizQuestion(
        question: 'That ________ be Tom. Tom is in England right now.',
        options: ['must', 'can\'t', 'might'],
        correctIndex: 1,
        explanation:
            'Tom\'un İngiltere\'de olduğu biliniyorsa, o kişi Tom olamaz ("can\'t").',
      ),
      GrammarQuizQuestion(
        question: 'There is no light in their window. They ________ be out.',
        options: ['must', 'can\'t', 'could'],
        correctIndex: 0,
        explanation:
            'Evde ışık yanmıyorsa dışarıda olduklarına dair güçlü bir çıkarım (must) yapılır.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ go to the party, but it depends on how I feel.',
        options: ['must', 'might', 'can\'t'],
        correctIndex: 1,
        explanation:
            'Kesin olmayan, duruma bağlı ihtimaller için "might" kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'Listen! That ________ be the phone ringing. It sounds too quiet.',
        options: ['can\'t', 'must', 'might'],
        correctIndex: 0,
        explanation:
            'Sese şüpheyle yaklaşıldığı ve imkansızlık sezildiği için "can\'t" (olamaz) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'You ________ be right, but let me check first.',
        options: ['must', 'might', 'can\'t'],
        correctIndex: 1,
        explanation:
            'Doğru olma ihtimalini kabul etmek ama emin olmamak durumunda "might" uygundur.',
      ),
      GrammarQuizQuestion(
        question:
            'He ________ be a doctor. He is wearing a white coat and a stethoscope.',
        options: ['must', 'might', 'can\'t'],
        correctIndex: 0,
        explanation:
            'Gözle görülür delillere dayanan güçlü tahmin için "must" kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'They ________ win the game, but the other team is very strong.',
        options: ['must', 'could', 'can\'t'],
        correctIndex: 1,
        explanation:
            'Mümkün olan ama garanti olmayan ihtimaller için "could" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'He is not here. He ________ be in the library.',
        options: ['must', 'might', 'can\'t'],
        correctIndex: 1,
        explanation: 'Zayıf ihtimal: "Kütüphanede olabilir."',
      ),
      GrammarQuizQuestion(
        question: 'You ________ be serious! That\'s impossible.',
        options: ['must', 'could', 'can\'t'],
        correctIndex: 2,
        explanation:
            'Şaşkınlık ve imkansızlık vurgusu için "can\'t" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'That ________ be the postman. He usually comes earlier.',
        options: ['might', 'can\'t', 'must'],
        correctIndex: 0,
        explanation:
            'Genelde erken geliyorsa, şu an gelenin o olması zayıf bir ihtimaldir.',
      ),
      GrammarQuizQuestion(
        question: 'She ________ know the answer; she\'s a genius.',
        options: ['must', 'can\'t', 'might'],
        correctIndex: 0,
        explanation: 'Güçlü çıkarım: "Biliyor olmalı."',
      ),
      GrammarQuizQuestion(
        question: 'It ________ be cold outside. Everyone is wearing a coat.',
        options: ['could', 'must', 'might'],
        correctIndex: 1,
        explanation: 'Gözleme dayalı güçlü tahmin: "Soğuk olmalı."',
      ),
      GrammarQuizQuestion(
        question: 'He ________ be at work. His car is not in the driveway.',
        options: ['must', 'might', 'can\'t'],
        correctIndex: 0,
        explanation: 'Kanıta dayalı güçlü tahmin.',
      ),
    ],
  ),
];

final List<GrammarTopic> b2GrammarTopics = [
  GrammarTopic(
    id: 'b2_1',
    level: 'B2',
    title: 'Mixed Conditionals',
    explanation:
        'Geçmişteki bir eylemin şu anki sonucunu veya şu anki bir durumun geçmişteki etkisini anlatır.\n\nYapı: If + Past Perfect, ... would + Verb',
    examples: [
      GrammarExample(
        en: 'If I had studied harder at university, I would have a better job now.',
        tr: 'Üniversitede daha çok çalışsaydım, şu an daha iyi bir işim olurdu.',
      ),
      GrammarExample(
        en: 'If I had been born in the US, I would speak better English now.',
        tr: 'ABD\'de doğmuş olsaydım, şu an daha iyi İngilizce konuşuyor olurdum.',
      ),
      GrammarExample(
        en: 'I wouldn\'t be so tired today if I had gone to bed earlier.',
        tr: 'Daha erken yatsaydım bugün bu kadar yorgun olmazdım.',
      ),
      GrammarExample(
        en: 'If he had taken the map, he wouldn\'t be lost now.',
        tr: 'Haritayı alsaydı şimdi kaybolmuş olmazdı.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'If you __________ your umbrella, you wouldn\'t be wet now.',
        options: [
          'hadn\'t forgotten',
          'didn\'t forget',
          'wouldn\'t have forgotten',
        ],
        correctIndex: 0,
        explanation:
            'Geçmişteki bir hatanın şu ana etkisini anlatmak için Past Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'If I ________ born in the US, I ________ speak better English now.',
        options: ['was / would', 'had been / would', 'was / would have'],
        correctIndex: 1,
        explanation:
            'Geçmişteki bir durumun (doğum) şu ana etkisi için Mix yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'If they ________ the game yesterday, they ________ champions today.',
        options: [
          'won / would be',
          'had won / would be',
          'had won / would have been',
        ],
        correctIndex: 1,
        explanation: 'Dünkü eylem (had won), bugünkü sonuç (would be).',
      ),
      GrammarQuizQuestion(
        question: 'I ________ at the party now if I ________ my flight.',
        options: [
          'would be / hadn\'t missed',
          'will be / didn\'t miss',
          'would be / wouldn\'t miss',
        ],
        correctIndex: 0,
        explanation:
            'Şu anki durum (would be), geçmişteki eyleme bağlıdır (hadn\'t missed).',
      ),
      GrammarQuizQuestion(
        question:
            'If she ________ so shy, she ________ have told you the truth.',
        options: ['isn\'t / would', 'weren\'t / would', 'hadn\'t been / would'],
        correctIndex: 1,
        explanation:
            'Genel bir kişilik özelliği (weren\'t), geçmişteki sonuca (would have told) karışmış.',
      ),
      GrammarQuizQuestion(
        question:
            'If you ________ more attention, you ________ know what to do.',
        options: ['paid / would', 'had paid / would', 'would pay / had'],
        correctIndex: 1,
        explanation:
            'Geçmişte dikkat etseydin (had paid), şimdi bilirdin (would know).',
      ),
      GrammarQuizQuestion(
        question:
            'If I ________ harder at school, I ________ have a better job now.',
        options: [
          'studied / would',
          'had studied / would',
          'had studied / would have',
        ],
        correctIndex: 1,
        explanation:
            'Geçmişteki çalışma eylemi (had studied), şu anki iş durumunu (would have) etkiliyor.',
      ),
      GrammarQuizQuestion(
        question: 'We ________ lost if we ________ a map with us.',
        options: [
          'wouldn\'t be / had taken',
          'won\'t be / took',
          'wouldn\'t have been / had taken',
        ],
        correctIndex: 0,
        explanation:
            'Şu anki durum (wouldn\'t be) geçmişteki bir eyleme (had taken) dayanıyor.',
      ),
      GrammarQuizQuestion(
        question: 'If he ________ a better athlete, he ________ won the race.',
        options: ['was / would have', 'were / would have', 'had been / would'],
        correctIndex: 1,
        explanation:
            'Genel özellik (were) ve geçmiş sonuç (would have won) kombinasyonu.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ you if I ________ so busy with work lately.',
        options: [
          'would have helped / hadn\'t been',
          'would help / wasn\'t',
          'would have helped / weren\'t',
        ],
        correctIndex: 0,
        explanation:
            'Geçmişteki yardım (would have helped) ve geçmişteki yoğunluk (hadn\'t been) Mixed Conditional tipidir.',
      ),
      GrammarQuizQuestion(
        question: 'If she ________ the money, she ________ it back by now.',
        options: [
          'had / would have paid',
          'had had / would pay',
          'had / will pay',
        ],
        correctIndex: 0,
        explanation:
            'Geçmişte parası olsaydı (had), şu ana kadar ödemiş olurdu (would have paid).',
      ),
      GrammarQuizQuestion(
        question:
            'If the weather ________ so bad, we ________ be at the beach.',
        options: ['wasn\'t / would', 'hadn\'t been / would', 'weren\'t / will'],
        correctIndex: 1,
        explanation:
            'Geçmişteki hava durumu (hadn\'t been), şu anki planı (would be) etkiliyor.',
      ),
      GrammarQuizQuestion(
        question: 'If they ________ the map, they ________ lost now.',
        options: [
          'had taken / wouldn\'t be',
          'took / wouldn\'t be',
          'take / won\'t be',
        ],
        correctIndex: 0,
        explanation: 'Geçmişteki eylem (had taken) ve şu anki sonuç.',
      ),
      GrammarQuizQuestion(
        question:
            'I ________ a millionaire today if I ________ that bitcoin in 2010.',
        options: [
          'would be / hadn\'t sold',
          'will be / didn\'t sell',
          'would be / wouldn\'t sell',
        ],
        correctIndex: 0,
        explanation:
            'Geçmişteki hata (hadn\'t sold), şu anki durum (would be).',
      ),
      GrammarQuizQuestion(
        question:
            'If you ________ so much last night, you ________ feel sick now.',
        options: [
          'hadn\'t eaten / wouldn\'t',
          'didn\'t eat / won\'t',
          'weren\'t eating / wouldn\'t',
        ],
        correctIndex: 0,
        explanation: 'Geçmiş eylem ve şu anki fiziksel durum.',
      ),
      GrammarQuizQuestion(
        question:
            'If she ________ a faster runner, she ________ have won yesterday.',
        options: ['were / would', 'is / would', 'were / would have'],
        correctIndex: 2,
        explanation: 'Genel özellik (were) ve geçmiş sonuç (would have won).',
      ),
      GrammarQuizQuestion(
        question:
            'If I ________ Turkish, I ________ have understood the movie last night.',
        options: ['spoke / would', 'had spoken / would', 'spoke / would have'],
        correctIndex: 2,
        explanation:
            'Genel yetenek (spoke) ve geçmiş sonuç (would have understood).',
      ),
      GrammarQuizQuestion(
        question: 'We ________ at the party now if we ________ the invitation.',
        options: [
          'would be / hadn\'t lost',
          'will be / didn\'t lose',
          'were / wouldn\'t lose',
        ],
        correctIndex: 0,
        explanation: 'Şu anki yer ve geçmiş eylem.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b2_2',
    level: 'B2',
    title: 'Passive Reporting Verbs',
    explanation:
        'Edilgen Raporlama: "Söyleniyor, inanılıyor, iddia ediliyor" gibi genel kanıları ifade etmek için kullanılır.',
    examples: [
      GrammarExample(
        en: 'It is believed that the company is losing money.',
        tr: 'Şirketin para kaybettiğine inanılıyor.',
      ),
      GrammarExample(
        en: 'The suspect is thought to have left the country.',
        tr: 'Şüphelinin ülkeyi terk ettiği düşünülüyor.',
      ),
      GrammarExample(
        en: 'It is said that this castle is haunted.',
        tr: 'Bu kalenin hayaletli olduğu söyleniyor.',
      ),
      GrammarExample(
        en: 'The prime minister is reported to be arriving tomorrow.',
        tr: 'Başbakanın yarın geleceği bildiriliyor.',
      ),
      GrammarExample(
        en: 'Ancient civilizations are thought to have used this tool.',
        tr: 'Kadim uygarlıkların bu aracı kullandığı düşünülüyor.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'The painting is thought __________ over 500 years ago.',
        options: [
          'to be painted',
          'to have been painted',
          'that it was painted',
        ],
        correctIndex: 1,
        explanation:
            'Geçmişte tamamlanmış bir eleyi raporlamak için "to have been + V3" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'It is said ________ this castle is haunted.',
        options: ['to', 'that', 'which'],
        correctIndex: 1,
        explanation: '"It is said/believed..." yapısından sonra "that" gelir.',
      ),
      GrammarQuizQuestion(
        question: 'He is believed ________ the most successful CEO in history.',
        options: ['to be', 'being', 'that he is'],
        correctIndex: 0,
        explanation: 'Subject + is believed + to be yapısı yaygındır.',
      ),
      GrammarQuizQuestion(
        question: 'The thieves ________ to have escaped through the window.',
        options: ['believe', 'are believed', 'is believed'],
        correctIndex: 1,
        explanation: 'Çoğul özne (thieves) için "are believed" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'It ________ that the economy will grow next year.',
        options: ['expects', 'is expected', 'was expecting'],
        correctIndex: 1,
        explanation: '"It is expected that..." kalıbı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'They are thought ________ the crime in broad daylight.',
        options: ['to commit', 'to have committed', 'committed'],
        correctIndex: 1,
        explanation:
            'Geçmişte bitmiş bir suçtan bahsederken "to have committed" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The new drug is reported ________ very effective.',
        options: ['to be', 'being', 'is'],
        correctIndex: 0,
        explanation:
            'Rapolanan durumlar için "is reported to be" yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'It ________ widely believed that the universe is expanding.',
        options: ['is', 'has', 'was'],
        correctIndex: 0,
        explanation:
            'Genel kanılar için "It is widely believed that..." kalıbı yaygındır.',
      ),
      GrammarQuizQuestion(
        question: 'Dinosaurs are known ________ millions of years ago.',
        options: ['to go extinct', 'to have gone extinct', 'going extinct'],
        correctIndex: 1,
        explanation:
            'Geçmişteki bir yok oluşu raporlamak için "to have gone extinct" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'He is said ________ five different languages fluently.',
        options: ['speaking', 'to speak', 'that he speaks'],
        correctIndex: 1,
        explanation:
            'Genel yetenek raporlamalarında "is said to speak" formu tercih edilir.',
      ),
      GrammarQuizQuestion(
        question: 'The project ________ estimated to cost 5 million dollars.',
        options: ['is', 'are', 'has'],
        correctIndex: 0,
        explanation:
            'Tahmin edilen maliyetler için "The project is estimated to..." kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'It ________ claimed that the artifact is a fake.',
        options: ['is', 'believed', 'reported'],
        correctIndex: 0,
        explanation:
            '"Iddia ediliyor" anlamında "It is claimed that..." yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The volcano ________ expected to erupt soon.',
        options: ['is', 'has', 'will'],
        correctIndex: 0,
        explanation: '"Expected to + V1" pasif raporlama yapısıdır.',
      ),
      GrammarQuizQuestion(
        question: 'He is thought ________ the keys by mistake.',
        options: ['to take', 'to have taken', 'taken'],
        correctIndex: 1,
        explanation:
            'Geçmişteki bir eylemi raporlamak için "to have + V3" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The suspect is reported ________ the building around 10 PM.',
        options: ['to enter', 'to have entered', 'entering'],
        correctIndex: 1,
        explanation: 'Geçmiş eylem raporlanıyor.',
      ),
      GrammarQuizQuestion(
        question: 'Ancient texts are believed ________ this event in detail.',
        options: ['to describe', 'describing', 'to have described'],
        correctIndex: 0,
        explanation:
            'Genel bir durumu/içeriği raporlamak için "to + V1" yeterlidir.',
      ),
      GrammarQuizQuestion(
        question: 'The bridge is estimated ________ over 200 years old.',
        options: ['is', 'to be', 'being'],
        correctIndex: 1,
        explanation: '"Estimated to be" standart kalıptır.',
      ),
      GrammarQuizQuestion(
        question: 'It is rumored ________ the company will close its doors.',
        options: ['that', 'to', 'which'],
        correctIndex: 0,
        explanation:
            '"It is rumored that..." dedikoduları aktarırken kullanılır.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b2_3',
    level: 'B2',
    title: 'Future Continuous & Perfect',
    explanation:
        '• Future Continuous: Yarın bu saatte uçuyor olacağım.\n• Future Perfect: Bu ayın sonunda uygulamamı bitirmiş olacağım.',
    examples: [
      GrammarExample(
        en: 'This time tomorrow, I will be flying to London.',
        tr: 'Yarın bu saatte Londra\'ya uçuyor olacağım.',
      ),
      GrammarExample(
        en: 'By the end of this month, I will have finished my app.',
        tr: 'Bu ayın sonunda uygulamamı bitirmiş olacağım.',
      ),
      GrammarExample(
        en: 'Wait! Don\'t call him now; he will be having dinner.',
        tr: 'Bekle! Onu şimdi arama; akşam yemeği yiyor olacak.',
      ),
      GrammarExample(
        en: 'In two years\' time, I will have completed my degree.',
        tr: 'İki yıl içinde diplomamı almış olacağım.',
      ),
      GrammarExample(
        en: 'We will be waiting for you at the airport.',
        tr: 'Havaalanında sizi bekliyor olacağız.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'By the time you get home, I __________ the dinner.',
        options: ['will cook', 'will be cooking', 'will have cooked'],
        correctIndex: 2,
        explanation:
            'Belli bir zamana kadar tamamlanacak eylemler için Future Perfect (will have + V3) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'This time next week, we ________ on the beach in Antalya.',
        options: ['will sit', 'will be sitting', 'will have sat'],
        correctIndex: 1,
        explanation:
            'Gelecekte o anda devam ediyor olacak eylem için Future Continuous kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I can\'t meet you at 6. I ________ a yoga class.',
        options: ['will attending', 'will have attended', 'will be attending'],
        correctIndex: 2,
        explanation:
            'Gelecekte o saatte meşgul olunacağını belirtmek için Continuous kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'How long ________ you ________ here by next June?',
        options: ['will / live', 'will / be living', 'will / have lived'],
        correctIndex: 2,
        explanation:
            'Gelecekteki bir tarihte eylemin ne kadar süredir devam ediyor olacağını sormak için Future Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Don\'t worry, the concert ________ by 10 PM.',
        options: ['will have finished', 'will be finishing', 'will finish'],
        correctIndex: 0,
        explanation:
            'Gelecekteki belirli bir zamana kadar bitmiş olacağı için Future Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The pilot says we ________ over the Alps in few minutes.',
        options: ['will fly', 'will be flying', 'will have flown'],
        correctIndex: 1,
        explanation:
            'Birkaç dakika içinde başlıyor ve devam ediyor olacak eylem için Continuous kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'By next Christmas, I ________ for this company for five years.',
        options: ['will be working', 'will have worked', 'will work'],
        correctIndex: 1,
        explanation:
            'Gelecekte tamamlanmış bir süreci ifade etmek için Future Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'At noon tomorrow, I ________ an important meeting.',
        options: ['will have attended', 'will be attending', 'will attend'],
        correctIndex: 1,
        explanation:
            'Yarın öğlen o anda devam ediyor olacak eylem için Continuous kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Will you ________ the report by the end of the day?',
        options: ['be finishing', 'have finished', 'finish'],
        correctIndex: 1,
        explanation:
            'Günün sonuna kadar "bitirmiş olacak mısın?" sorusu Future Perfect gerektirir.',
      ),
      GrammarQuizQuestion(
        question: 'They ________ to a new house by this time next year.',
        options: ['will have moved', 'will be moving', 'moved'],
        correctIndex: 0,
        explanation:
            'Gelecek yılın bu zamanına kadar taşınmış olma eylemi tamamlanmış olacağı için Future Perfect kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I guess I ________ a movie when you arrive.',
        options: ['will watch', 'will be watching', 'will have watched'],
        correctIndex: 1,
        explanation:
            'Geliş anında devam ediyor olacak eylem için Future Continuous uygundur.',
      ),
      GrammarQuizQuestion(
        question: 'In 50 years, everything ________ changed completely.',
        options: ['will be', 'will have', 'will'],
        correctIndex: 1,
        explanation:
            '50 yıl sonra her şeyin "değişmiş olacağını" anlatmak için Future Perfect (will have + V3) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'They ________ traveling around Europe for months by then.',
        options: ['will have been', 'will be', 'will have'],
        correctIndex: 0,
        explanation:
            'Gelecekteki bir ana kadar devam etmiş olan süreci belirtmek için Future Perfect Continuous (will have been) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ my degree by next summer.',
        options: ['will have finished', 'will be finishing', 'finish'],
        correctIndex: 0,
        explanation: 'Gelecekte bitmiş olacak eylem.',
      ),
      GrammarQuizQuestion(
        question: 'Don\'t come at 8:00. We ________ dinner.',
        options: ['will have', 'will have had', 'will be having'],
        correctIndex: 2,
        explanation: 'O anda devam ediyor olacak eylem.',
      ),
      GrammarQuizQuestion(
        question: 'By the time she arrives, the movie ________.',
        options: ['will start', 'will be starting', 'will have started'],
        correctIndex: 2,
        explanation: 'Varış anından önce bitmiş olacak eylem.',
      ),
      GrammarQuizQuestion(
        question: 'Next week, I ________ in this house for 10 years.',
        options: ['will live', 'will be living', 'will have lived'],
        correctIndex: 2,
        explanation: 'Zaman tamamlama vurgusu.',
      ),
      GrammarQuizQuestion(
        question: 'Wait! At 3 PM, I ________ to work.',
        options: ['will drive', 'will be driving', 'will have driven'],
        correctIndex: 1,
        explanation: 'Gelecekteki bir anın meşguliyeti.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b2_4',
    level: 'B2',
    title: 'Inversion (Devrik Cümle)',
    explanation:
        'Cümleye vurgu katmak için kullanılır. Genellikle zarflar (Never, Seldom) başa gelir.',
    examples: [
      GrammarExample(
        en: 'Never have I seen such a beautiful sunset.',
        tr: 'Asla böyle güzel bir gün batımı görmedim.',
      ),
      GrammarExample(
        en: 'Hardly had I left the office when it started to rain.',
        tr: 'Ofisten ayrılır ayrılmaz yağmur yağmaya başladı.',
      ),
      GrammarExample(
        en: 'Not only did he win the race, but he also broke the record.',
        tr: 'Sadece yarışı kazanmakla kalmadı, aynı zamanda rekoru da kırdı.',
      ),
      GrammarExample(
        en: 'Seldom does one see such a talented player.',
        tr: 'Böyle yetenekli bir oyuncu nadiren görülür.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question:
            '"Hardly __________ the office when the phone started ringing."',
        options: ['I had left', 'had I left', 'did I left'],
        correctIndex: 1,
        explanation:
            '"Hardly" ile başlayan devrik cümlelerde yardımcı fiil (had) özneden önce gelir.',
      ),
      GrammarQuizQuestion(
        question: '"Seldom ________ such a talented player."',
        options: ['one sees', 'does one see', 'sees one'],
        correctIndex: 1,
        explanation:
            '"Seldom" ile başlayan devrik yapıda soru formu (does + subject + V1) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Never ________ so much fun in my life!',
        options: ['I have had', 'have I had', 'did I had'],
        correctIndex: 1,
        explanation:
            '"Never" ile başlayan devrik yapıda yardımcı fiil (have) başa gelir.',
      ),
      GrammarQuizQuestion(
        question: 'Only after he arrived ________ the truth.',
        options: ['I knew', 'did I know', 'I had known'],
        correctIndex: 1,
        explanation:
            '"Only after..." yapısından sonra cümle soru formuna döner ("did I know").',
      ),
      GrammarQuizQuestion(
        question: 'Under no circumstances ________ you touch this wire.',
        options: ['should', 'you should', 'can'],
        correctIndex: 0,
        explanation:
            '"Under no circumstances" devrik yapı gerektirir (should + subject).',
      ),
      GrammarQuizQuestion(
        question: 'Little ________ that he was being set up.',
        options: ['he realized', 'did he realize', 'had he realize'],
        correctIndex: 1,
        explanation: '"Little" zarfı devrik yapı gerektirir.',
      ),
      GrammarQuizQuestion(
        question:
            'Not only ________ the exam, but she also got the highest grade.',
        options: ['she passed', 'did she pass', 'passed she'],
        correctIndex: 1,
        explanation:
            '"Not only" ile başlayan cümlelerde devrik yapı (did + subject + V1) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Rarely ________ such a beautiful view.',
        options: ['we see', 'do we see', 'saw we'],
        correctIndex: 1,
        explanation: '"Rarely" (nadiren) ifadesi devrik yapı gerektirir.',
      ),
      GrammarQuizQuestion(
        question:
            'Scarcely ________ begun the presentation when the power went out.',
        options: ['I had', 'had I', 'did I'],
        correctIndex: 1,
        explanation:
            '"Scarcely" ile kurulan devrik cümlelerde "had I + V3" yapısı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Only then ________ how serious the situation was.',
        options: ['I realized', 'did I realize', 'had I realized'],
        correctIndex: 1,
        explanation: '"Only then" ifadesinden sonra yüklem ve özne devrilir.',
      ),
      GrammarQuizQuestion(
        question:
            'No sooner ________ reached the station ________ the train left.',
        options: ['had I / than', 'did I / when', 'had I / when'],
        correctIndex: 0,
        explanation:
            '"No sooner" yapısı "than" ile birlikte devrik olarak (had I) kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'In no way ________ be held responsible for this.',
        options: ['can I', 'I can', 'could'],
        correctIndex: 0,
        explanation:
            '"In no way" ile başlayan cümleler devrik yapıda (can I) kurulur.',
      ),
      GrammarQuizQuestion(
        question: 'Only if it rains ________ the match be cancelled.',
        options: ['will', 'it will', 'does'],
        correctIndex: 0,
        explanation:
            '"Only if" yapısı ana cümlede devrik yapı (will + subject) gerektirir.',
      ),
      GrammarQuizQuestion(
        question: 'On no account ________ this door be left unlocked.',
        options: ['should', 'you should', 'must'],
        correctIndex: 0,
        explanation: '"On no account" devrik yapı gerektirir.',
      ),
      GrammarQuizQuestion(
        question:
            'Such ________ the intensity of the storm that trees were uprooted.',
        options: ['is', 'was', 'did'],
        correctIndex: 1,
        explanation:
            '"Such + be + subject" devrik yapısı vurgu için kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Not until I saw him ________ I believe he was safe.',
        options: ['did', 'I did', 'had'],
        correctIndex: 0,
        explanation: '"Not until" devrik yapı gerektiren bir zarf öbeğidir.',
      ),
      GrammarQuizQuestion(
        question: 'Barely ________ the phone when it started ringing again.',
        options: ['had I put down', 'I had put down', 'did I put down'],
        correctIndex: 0,
        explanation: '"Barely" ile devrik yapı kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Only by working hard ________ you succeed.',
        options: ['will', 'did', 'do'],
        correctIndex: 0,
        explanation:
            '"Only by..." geleceğe yönelik bir koşul ve sonuç (vurgulu) belirtir.',
      ),
    ],
  ),
  GrammarTopic(
    id: 'b2_5',
    level: 'B2',
    title: 'Modal Verbs in the Past',
    explanation:
        'Geçmişteki olaylar hakkında çıkarım, pişmanlık veya eleştiri bildirmek için kullanılır.',
    examples: [
      GrammarExample(
        en: 'I should have told him the truth.',
        tr: 'Ona gerçeği söylemeliydim. (Pişmanlık)',
      ),
      GrammarExample(
        en: 'She must have forgotten her keys.',
        tr: 'Anahtarlarını unutmuş olmalı. (Çıkarım)',
      ),
      GrammarExample(
        en: 'He couldn\'t have stolen the money; he was with me.',
        tr: 'Parayı çalmış olamaz; benimleydi.',
      ),
      GrammarExample(
        en: 'You might have mentioned that earlier!',
        tr: 'Bunu daha önce söyleyebilirdin! (Eleştiri)',
      ),
      GrammarExample(
        en: 'The street is wet. It must have rained last night.',
        tr: 'Cadde ıslak. Dün gece yağmur yağmış olmalı.',
      ),
    ],
    quizQuestions: [
      GrammarQuizQuestion(
        question: 'You __________ more careful! You almost caused an accident.',
        options: ['should have been', 'must have been', 'could be'],
        correctIndex: 0,
        explanation:
            'Geçmişteki bir hata için eleştiri bildirirken "should have been" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The street is wet. It ________ have rained last night.',
        options: ['must', 'should', 'can\'t'],
        correctIndex: 0,
        explanation: 'Geçmişe dair güçlü bir çıkarım: "Yağmış olmalı."',
      ),
      GrammarQuizQuestion(
        question: 'He didn\'t come to the party. He ________ the invitation.',
        options: [
          'shouldn\'t have missed',
          'must have missed',
          'might have missed',
        ],
        correctIndex: 1,
        explanation: 'Gelmediyse davetiyeyi "kaçırmış olmalı" (çıkarım).',
      ),
      GrammarQuizQuestion(
        question: 'I feel sick. I ________ so much pizza last night.',
        options: [
          'mustn\'t have eaten',
          'shouldn\'t have eaten',
          'couldn\'t have eaten',
        ],
        correctIndex: 1,
        explanation:
            'Geçmişteki bir eylemden duyulan pişmanlık için "shouldn\'t have + V3" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'Where is my wallet? I ________ it on the bus.',
        options: ['must leave', 'might have left', 'should have left'],
        correctIndex: 1,
        explanation:
            'Düşük/Orta ihtimalli geçmiş tahmini: "Bırakmış olabilirim."',
      ),
      GrammarQuizQuestion(
        question: 'The test was very hard. You ________ very hard to pass it.',
        options: ['should study', 'must have studied', 'can study'],
        correctIndex: 1,
        explanation: 'Zor testi geçtiysen, "çok çalışmış olmalısın" (çıkarım).',
      ),
      GrammarQuizQuestion(
        question:
            'They ________ forgotten about the meeting; they are never late.',
        options: ['should have', 'must have', 'can have'],
        correctIndex: 1,
        explanation:
            'Asla geç kalmayan birilerinin geç kalması durumunda "unutmuş olmalılar" (must have) denir.',
      ),
      GrammarQuizQuestion(
        question: 'You ________ me! I was waiting for hours.',
        options: ['could have called', 'must call', 'should call'],
        correctIndex: 0,
        explanation:
            'Geçmişe yönelik sitem ve imkan belirtmek için "could have called" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'The window is broken. A ball ________ hit it.',
        options: ['might have', 'should have', 'can have'],
        correctIndex: 0,
        explanation:
            'Geçmişteki bir olaya dair ihtimal yürütmek için "might have" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ that expensive watch. It was a waste of money.',
        options: [
          'mustn\'t have bought',
          'shouldn\'t have bought',
          'couldn\'t have bought',
        ],
        correctIndex: 1,
        explanation:
            'Geçmişteki bir harcamadan duyulan pişmanlık için "shouldn\'t have" kullanılır.',
      ),
      GrammarQuizQuestion(
        question:
            'He ________ finished his book already! He only started it this morning.',
        options: ['must have', 'can\'t have', 'should have'],
        correctIndex: 1,
        explanation:
            'Sabah başlanılan bir kitabın bitmiş olmasına duyulan şüphe/imkansızlık için "can\'t have" kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'They ________ lost. They don\'t have a map or a phone.',
        options: ['might have gotten', 'should have got', 'must getting'],
        correctIndex: 0,
        explanation:
            'Geçmişte/Süreç içinde "kaybolmuş olabilirler" ihtimali için Past Modal kullanılır.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ the earlier train. Now I\'m going to be late.',
        options: ['should take', 'should have taken', 'must have taken'],
        correctIndex: 1,
        explanation: 'Geçmişteki bir fırsatın kaçırılması (pişmanlık).',
      ),
      GrammarQuizQuestion(
        question: 'She ________ been happy to see you; she was smiling.',
        options: ['must have', 'should have', 'can\'t have'],
        correctIndex: 0,
        explanation: 'Kanıta dayalı (smiliing) geçmiş çıkarımı.',
      ),
      GrammarQuizQuestion(
        question: 'We ________ the wrong turn back there.',
        options: ['must have taken', 'might took', 'should take'],
        correctIndex: 0,
        explanation: 'Geçmişteki bir eyleme dair güçlü tahmin.',
      ),
      GrammarQuizQuestion(
        question:
            'He ________ finished his homework already. It was 50 pages long!',
        options: ['can\'t have', 'must have', 'might have'],
        correctIndex: 0,
        explanation:
            '50 sayfalık ödevin bitmiş olma ihtimaline duyulan güçlü şüphe.',
      ),
      GrammarQuizQuestion(
        question: 'You ________ me to the airport! I could have taken a taxi.',
        options: [
          'didn\'t need to drive',
          'shouldn\'t have driven',
          'must not drive',
        ],
        correctIndex: 1,
        explanation: 'Gerekli olmayan ama yapılmış bir eylem için eleştiri.',
      ),
      GrammarQuizQuestion(
        question: 'Someone ________ my sandwich! It was here a minute ago.',
        options: ['must have eaten', 'should have eaten', 'could eat'],
        correctIndex: 0,
        explanation: 'Eksilen bir şeye dair net çıkarım.',
      ),
      GrammarQuizQuestion(
        question: 'I ________ more carefully when I was painting.',
        options: ['should have looked', 'must have look', 'could look'],
        correctIndex: 0,
        explanation: 'Geçmişteki bir sürece dair pişmanlık.',
      ),
    ],
  ),
];
