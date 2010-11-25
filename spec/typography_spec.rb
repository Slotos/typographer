require 'spec_helper'

describe TypographyHelper, 'with typography' do
  include ActionView::Helpers::TextHelper

  it "should have t helper" do
    ty('typography me please').should == 'typography me&nbsp;please'
  end

  it "should make russian quotes for quotes with first russian letter" do
    ty('"текст"').should == '&#171;текст&#187;'
    ty('Text "текст" text').should == 'Text &#171;текст&#187; text'
    ty('Text "текст" text "Другой текст" ').should == 'Text &#171;текст&#187; text &#171;Другой текст&#187; '
  end

  it "should do the same with single quotes" do
    ty('\'текст\'').should == '&#171;текст&#187;'
    ty('Text \'текст\' text').should == 'Text &#171;текст&#187; text'
    ty('Text \'текст\' text \'Другой текст\' ').should == 'Text &#171;текст&#187; text &#171;Другой текст&#187; '
  end


  it "should create second-level russian quotes" do
    ty('Текст "в кавычках "второго уровня""').should == 'Текст &#171;в кавычках &#132;второго уровня&#147;&#187;'
  end


  it "should make english quotes for quotes with first non-russian letter" do
    ty('"text"').should == '&#147;text&#148;'
    ty('Text "text" text').should == 'Text &#147;text&#148; text'
    ty('Text "text" text "Another text" ').should == 'Text &#147;text&#148; text &#147;Another text&#148; '
  end

  it "should do the same with single quotes" do
    ty('\'text\'').should == '&#147;text&#148;'
    ty('Text \'text\' text').should == 'Text &#147;text&#148; text'
    ty('Text \'text\' text \'Another text\' ').should == 'Text &#147;text&#148; text &#147;Another text&#148; '
  end

  it "should create second-level english quotes" do
    ty('Text "in quotes "second level""').should == 'Text &#147;in&nbsp;quotes &#145;second level&#146;&#148;'
  end


  it "should not replace quotes inside html tags" do
    ty('<a href="ссылка">ссылка</a>').should == '<a href="ссылка">ссылка</a>'
    ty('<a href=\'ссылка\'>"ссылка"</a>').should == '<a href=\'ссылка\'>&#171;ссылка&#187;</a>'

    ty('<a href=\'link\'>link</a>').should == '<a href=\'link\'>link</a>'
    ty('<a href="link">"link"</a>').should == '<a href="link">&#147;link&#148;</a>'

    ty(' one">One</a> <a href="two"></a> <a href="three" ').should == ' one">One</a> <a href="two"></a> <a href="three" '
  end
  
  it "should make english and russian quotes in the same string" do
    ty('"Кавычки" and "Quotes"').should == '&#171;Кавычки&#187; and &#147;Quotes&#148;'
    ty('"Quotes" и "Кавычки"').should == '&#147;Quotes&#148; и &#171;Кавычки&#187;'

    ty('"Кавычки "второго уровня"" and "Quotes "second level""').should == '&#171;Кавычки &#132;второго уровня&#147;&#187; and &#147;Quotes &#145;second level&#146;&#148;'
    ty('"Quotes "second level"" и "Кавычки "второго уровня""').should == '&#147;Quotes &#145;second level&#146;&#148; и &#171;Кавычки &#132;второго уровня&#147;&#187;'
  end

  it "should replace -- to &mdash;" do
    ty('Replace -- to mdash please').should == 'Replace&nbsp;&mdash; to&nbsp;mdash please'
  end

  it "should replace \"word - word\" to \"word&nbsp;&mdash; word\"" do
    ty('word - word').should == 'word&nbsp;&mdash; word'
  end

  it "should insert &nbsp; before each &mdash; if it has empty space before" do
    ty('Before &mdash; after').should == 'Before&nbsp;&mdash; after'
    ty('Before	 &mdash; after').should == 'Before&nbsp;&mdash; after'
    ty('Before&mdash;after').should == 'Before&mdash;after'
  end


  it "should insert &nbsp; after small words" do
    ty('an apple').should == 'an&nbsp;apple'
  end

  it "should insert &nbsp; after small words" do
    ty('I want to be a scientist').should == 'I&nbsp;want to&nbsp;be&nbsp;a&nbsp;scientist'
  end

  it "should insert &nbsp; after small words with ( or dash before it" do
    ty('Apple (an orange)').should == 'Apple (an&nbsp;orange)'
  end

  it "should not insert &nbsp; after small words if it has not space after" do
    ty('Хорошо бы.').should == 'Хорошо бы.'
    ty('Хорошо бы').should == 'Хорошо бы'
    ty('Хорошо бы. Иногда').should == 'Хорошо бы. Иногда'
  end

  it "should insert <span class=\"nobr\"></span> around small words separated by dash" do
    ty('Мне фигово что-то').should == 'Мне фигово <span class="nobr">что-то</span>'
    ty('Как-то мне плохо').should == '<span class="nobr">Как-то</span> мне плохо'
    ty('хуе-мое').should == '<span class="nobr">хуе-мое</span>'
  end

  it "should not insert <span class=\"nobr\"></span> around words separated by dash if both of them are bigger than 3 letters" do
    ty('мальчик-девочка').should == 'мальчик-девочка'
  end


  it "should escape html if :escape_html => true is passed" do
    ty('< & >',:escape_html => true).should == '&lt; &amp; &gt;'
  end

  it "should replace single quote between letters to apostrophe" do
    ty('I\'m here').should == 'I&#146;m here'
  end


  it "should typography real world examples" do
    ty('"Читаешь -- "Прокопьев любил солянку" -- и долго не можешь понять, почему солянка написана с маленькой буквы, ведь "Солянка" -- известный московский клуб."').should == '&#171;Читаешь&nbsp;&mdash; &#132;Прокопьев любил солянку&#147;&nbsp;&mdash; и&nbsp;долго не&nbsp;можешь понять, почему солянка написана с&nbsp;маленькой буквы, ведь &#132;Солянка&#147;&nbsp;&mdash; известный московский клуб.&#187;'
  end

  it "should typography real world examples" do
    ty('"Заебалоооооо" противостояние образует сет, в частности, "тюремные психозы", индуцируемые при различных психопатологических типологиях.',:escape_html => true).should == '&#171;Заебалоооооо&#187; противостояние образует сет, в&nbsp;частности, &#171;тюремные психозы&#187;, индуцируемые при различных психопатологических типологиях.'
  end

  it "should typography real world examples" do
    ty('"They are the most likely habitat that we\'re going to get to in the foreseeable future," said NASA Ames Research Center\'s Aaron Zent, the lead scientist for the probe being used to look for unfrozen water.').should == '&#147;They are the most likely habitat that we&#146;re going to&nbsp;get to&nbsp;in&nbsp;the foreseeable future,&#148; said NASA Ames Research Center&#146;s Aaron Zent, the lead scientist for the probe being used to&nbsp;look for unfrozen water.'
  end
  
  it "should typography real wordl examples" do
    ty('Фирменный стиль: от полиграфии к интернет-решениям (в рамках выставки «Дизайн и Реклама 2009»)').should == 'Фирменный стиль: от&nbsp;полиграфии к&nbsp;интернет-решениям (в&nbsp;рамках выставки «Дизайн и&nbsp;Реклама 2009»)'
  end

  it "should typography real world examples" do
    ty('решениям (в рамках выставки').should == 'решениям (в&nbsp;рамках выставки'
  end

  it "should typography real world examples" do
    ty('Реанимация живописи: «новые дикие» и «трансавангард» в ситуации арт-рынка 1980-х').should == 'Реанимация живописи: «новые дикие» и&nbsp;«трансавангард» в&nbsp;ситуации арт-рынка <span class="nobr">1980-х</span>'
  end
  
  it "should typography real world examples" do
    ty('«Искусство после философии&#187; – концептуальные стратегии Джозефа Кошута и Харальда Зеемана').should == '«Искусство после философии&#187;&nbsp;&mdash; концептуальные стратегии Джозефа Кошута и&nbsp;Харальда Зеемана'
  end
  
  it "should typography real world examples" do
    ty('Испанцы говорят, что целовать мужчину без усов, - всё равно что есть яйцо без соли').should == 'Испанцы говорят, что целовать мужчину без усов,&nbsp;&mdash; всё равно что есть яйцо без соли'
  end

  
  
  # it "should fail" do
  #   1.should == 2
  # end

end
