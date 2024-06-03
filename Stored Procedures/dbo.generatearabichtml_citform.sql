SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROC [dbo].[generatearabichtml_citform]
AS
BEGIN
DECLARE @htmlarabic NVARCHAR(MAX);
SELECT @htmlarabic = Pdftemplate from CitForm where Language = 'en';

set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total additions(Total 11301 to 11309)',N'اجمالي الإضافات (م');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Prepaid expenses',N'مصاريف مدفوعة مقدما');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Establishment expenses',N'مصاريف تأسيس');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Accrued expenses',N'مصاريف مستحقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other allocations',N'مخصصات أخرى');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Dividents payables',N'توزيعات أرباح مستحقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Are there are any amendment in the ownership of the company or in the partners shares in capital profits?',N'هل تم إجراء أي تعديل في ملكية الشركة أو في حصص الشركاء في رأس المال أو الأرباح ؟');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'If yes supporting documents and updated registration form to be attached.',N'إذا كانت الإجابة بنعم أرفق المستندات اللازمة مع تحديث نموذج التسجيل .');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'A Chartered Accountant must certify this return if the gross taxable income exceeds One million Saudi Riyals  ',N'٩ - تعد الشركة والمحاسب القانوني مسؤولين مسؤولية كاملة عن صحة هذه البيانات الواردة بالإقرار والتي يجب أن تكون متفقة مع سجلات ودفاتر الشركة النظامية، كما ان عدم تحري الدقة أو عدم صحة أو تعمد اخفاء بعض بياناته سوف يؤدي الى اتخاذ المصلحة لكافة الإجراءات الازمة في هذا الشأن ، مما يؤدي إلى التأخر في انهاء اجراءات الحصول عيلي الشهادة.');

--header
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Form No.10 (Standard)',N'نموذج رقم (الموحد)')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Branch',N'فرع ');  
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Financial No:',N'الرقم المالـي');  
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'BASIC INFORMATION',N'معلــومات أسـاسية ')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(Zakat/Tax) declaration for all tax/zakat payers who submit declaration on statutory accounts basis',
N'=الاقرار (الزكوي / الضريبي) لكافة المكلفين 
ممن يحاسبون بموجب حسابات نظامية')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Commercial Name',N'الاسم التجاري');  
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Legal Status',N'الكيان القانوني	');  
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Description of main activity',N'وصف النشاط الرئيسي');  
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Main Activity',N'النشاط الرئيس');  
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Address',N'العنوان');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Saudi S/H in capital',N'حصة الشريك السعودي وحكمه');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Non-Saudi S/H share in capital',N'حصة غير السعوديين الشريك ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Saudi S/H in profit',N'حصة الربح من السعودية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Non-Saudi S/H share in profit',N'حصة الأرباح من غير السعوديين');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Financial Year',N'السنة الماليــة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(For ZATCA use only)',N'(لاستخدام المصلحة فقط)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Code :',N'الرمز:');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Document',N'وثيقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Location No.',N'رقم الموقع')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Location',N'الموقـع');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'P.O. Box',N'ص . ب');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Zip code',N'الرمز');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Telephone',N'هاتف');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Fax',N'فاكس	');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'E-mail',N'بريد إلكتروني ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Building',N'البناية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Street',N'الشارع');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Area',N'الحـي ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'City',N'المدينـة	');

--SECTION A--
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(A): INCOME FROM OPERATIONAL ACTIVITY',N'(أ) : الدخل ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Income from Operational Activity',N'الايرادات من النشاط التشغيلي');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Income from Insurance',N'الإيرادات من نشاط التأمين (جدول ١ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Income from Contracts',N' الإيرادات من العقود (جدول ٢ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total Income from Main Activities(Total of Items 10101 to 10103)',
N' اجمالي الإيرادات من النشاط التشغيلي ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total other income (Total of items 10201 to 10207)',N'  إجمالي الايرادات الأخرى ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Do you have other income or gains/losses?',N'ﻫﻞ ﻟﺪﻳﻚ اى إﻳﺮادات أﺧﺮى او أرﺑﺎح/ﺧﺴﺎﺋﺮ ؟  ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Capital gains/ (losses)',N'مكاسب/خسائر رأسمالية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other Income',N'ايرادات أخرى');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total revenues(10100 + 10200)',N'إجمالي الايرادات ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Saudi Riyals',N'ريــــال ');

--SECTION B--
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(B): COSTS AND EXPENSES',N'ب -  التكاليف والمصاريف');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Inventory-Opening Balance',N'مخزون أول المدة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'External purchases',N'مشتريات خارجية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Internal purchases',N'مشتريات داخلية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Less:Inventory-Ending Balance',N'مخزون آخر المدة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Cost of goods sold(Sum 10401 to 10403:Loss 10404)',N'تكلفة البضاعة المباعة (١٠٤٠');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'COST OF GOODS SOLD',N'تكاليف البضاعة المباعة (١٠٤٠٠)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Subcontractors',N'المقاولون ﻣﻦ اﻟﺒﺎﻃﻦ  ( جدول ٣ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Machinery and equipment rentals',N'استئجار الآت والمعدات ( جدول ٤ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Repair and Maintenance expenses',N'مصاريف الصيانة والإصلاح');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Basic Salaries and housing allowance',N'الرواتب الأساسية وبدل السكن');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other employees'' benefits',N'مزايا الأخرى للموظفين');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Social insurance expenses(GOSI) -  Saudis',N'مصاريف التأمينات الاجتماعية  - السعوديون');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Social insurance expenses(GOSI) - Foreigners',N'مصاريف التأمينات الاجتماعية - الأجانب');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Provisions made during the year',N'المخصصات المكونة خلال العام ( جدول ٥ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Royalties, technical services, consultancy and professional fees',N'الإتاوات وأتعاب فنية واستشارية ومهنية ( جدول ٦ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Donations',N'تبرعات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Book Depreciation',N'الاستهلاك الدفتري');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Reasearch and Development Expenses',N'مصاريف البحوث والتطوير');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other expenses',N'مصاريف أخرى ( جدول ٧ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total expenses(Sum of 10501 to 10513)',N'إجمالي المصاريف ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total COGS And Expenses(10400+10500)',N'إجمالي المصاريف وتكلفة البضاعة المباعة ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Accounting net profit/(loss)(10300-10600)',N'صافي الربح/ الخسارة الدفترية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'EXPENSES',N'المصاريف');
--SECTION C--
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(C): ADJUSTMENTS ON NET PROFIT-LOSS',N'ج -  التعديلات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Accounting net profit /(loss), add:',N'صافي الربح / (الخسارة) الدفترية ، يضاف إليه :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Adjustment on Net Profit',N'التعديلات على صافي الربح ( جدول ٨ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Repair and improvement cost exceeds legal threshold',N'مصاريف صيانة وإصلاح زائدة عن الحد المسموح به ( جدول ٩)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Provisions utilized during the year',N'المستخدم من المخصصات السابق ردها للوعاء ( جدول ٥ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Provisions charged on accounts for the period',N'مخصصات محملة على حسابات الفترة ( جدول ٥ )')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Depreciation differentials',N'فروقات استهلاك ( جدول ٩)')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Loan changes in excess of the legal threshold',N'عوائد القروض الزائدة عن الحد المسموح ( جدول ١٠)')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total Zakat adjustments (Total of items 10901 & 10904)',N'إجمالي التعديلات الزكوية (إجم')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total CIT adjustments(Total of items 10901 to 10906)',N'إجمالي التعديلات الضريبية (إجمالي البند من ١٠٩٠١ إلى ١٠٩٠٦)')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Zakatable net adjusted profit / (loss)(10800 + 10900)',N'صافي الربح/ الخسارة المعدلة الزكوي (١٠٨٠')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Net CIT profit /(loss) after amendments',N'صافي الربح/ الخسارة المعدلة الضريبي ')
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'ADJUSTMENTS',N'التعديلات')


set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Non saudis share in the realized capital gains from the disposal of securities traded in the Saudi financial market',N'حصته من المكاسب الرأسمالية المحققة من التخلص من الأوراق المالية المعفاة نظاما');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Cash or in-kind dividends due from the investments of the resident capital association in other associations legally exempt',N'حصته من التوزيعات النقدية أو العينية المستحقة من استثمارات شركة الأموال المقيمة في شركات أخرى المعفاة نظاما');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total additions',N'إجمالي الإضافات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total Deductions (Total of 12101 to 12104)',N'إجمالي الحسميات');

--SECTION D--
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(D): ZAKAT COMPUTATION ON SAUDI SHARES',N'د -  الوعاء الزكوي');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Capital',N'رأس المال');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Retained earnings',N'الأرباح المدورة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Zakat Net Adjusted profit / (loss)',N'صافي ربح / خسارة الزكاة بعد التعديلات (');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Provisions',N'المخصصات ( جدول ٥ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Reserves',N'الاحتياطيات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Loans and the equivalents',N'الديون وما في حكمها ( جدول ١٣)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Fair value change',N'التغير بالقيمة العادلة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other liabilities and equity items financed deducted items',N'بنود حقوق الملكية أو مطلوبات أخرى مولت أصول حسمت من الوعاء');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other additions',N'إضافات أخرى ( جدول ١٤)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Less: his share in',N'الحسميات :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Net fixed assets and the equivalents',N'صافي الأصول الثابتة وما في حكمها');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Investments out of the territory',N'الاستثمارات في منشأة خارج المملكة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Investments in local companies that subjects to zakat',N'الاستثمارات في منشأة داخل المملكة لغير المتاجرة وتخضع لجباية الزكاة ( جدول ١٥ )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Adjusted carried forward losses',N'خسائر مرحلة معدلة ( جدول ١١ب)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Properties and projects under development for selling',N'عقارات ومشاريع تحت التطوير معدة للبيع ( جدول ١٦)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other zakat deductions',N'حسمیات أخرى ( جدول ١٧)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total deductions (Total of items 11401 to 11406)',N'إجمالي الحسميات (');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total base',N'اجمالي الوعاء');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Zakat base',N'الوعاء الزكوي');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Zakat on Investments in external entities as per the certified accountant',N'زكاة الاستثمارات الخارجية طبقا لشهادة المحاسب القانوني');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total zakat payable',N'إجمالي الزكاة المستحقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'ADDITIONS',N'الاضافات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'DEDUCTIONS',N'الحسميات');

--section e--
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(E):TAX BASE',N'هـ. اضافات أو حسميات للوعاء الضريبي');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Net CTI profit / (loss) after amendments',N'صافي الربح/ الخسارة المعدلة الضريبي');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Losses in the invested company',N'الحصة في خسائر الشركة المستثمر فيها');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total additions',N'إجمالي الإضافات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Carried forward adjusted losses upto 25%of current year profit',N'حصته من الخسائر المرحلة المعدلة بحد أقصى ٢٥% من الربح المعدل طبقاً لإقرار المكلف ( جدول ١١- ا )');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Gains in the invested company',N'حصته من أرباح الشركة المستثمر فيها');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Taxable amount for the Insurance companies of the Non-residents which practiced activity through a permenant  establishment according to the table',N'الدخل الخاضع للضريبة على شركات التأمين الغير مقيمة والتي مارست نشاط من خلال منشأة دائمة ( جدول ١٢)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Taxable amount(11200+12000-12100)',N'الوعاء الخاضع للضريبة (١١');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Income tax on the share of non-Saudis',N'ضريبة الدخل على حصة الجانب الضريبي ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Taxes Due',N'الضرائب المستحقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total Income Tax Payable',N'إجمالي ضريبة الدخل المستحقة');

--section f--

set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'(F): BALANCE SHEET AS AT  ',N'ز0 قائمة المركز المالي كما في  	٣١ ديسمبر ٢٠٢١');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Description',N'مفردات');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Begining Balance (SAR)',N'رصيد بداية الفترة (ريال سعودي)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Ending Balance (SAR)',N'رصيد نهاية الفترة (ريال سعودي)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Cash On hand at banks',N'نقد بالصندوق ولدى البنوك');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Short term investments',N'استثمارات قصيرة الأجل');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Account receivable and debit balances',N'مدينون وأرصدة مدينة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Merchandise Inventory',N'مخزون سلعي');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Accrued Revenues',N'إيرادات مستحقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Prepaid expenses',N'مصاريف مدفوعة مقدما');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Due from related parties',N'مستحق من أطراف ذات علاقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Other current assets',N'أصول متداولة أخرى');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total of Current assets',N'إجمالي الاصول متداولة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Long term investments',N'استثمارات طويلة الأجل');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Net assets (net book value of fixed assets)',N'صافي القيمة الدفترية للأصول الثابتة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Construction in progress(Work in Progress)',N'إنشاءات تحت التنفيذ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Others non-current assets',N'أصول غير متداولة أخرى');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total of non-current assets',N'أصول غير متداولة أخرى');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Patents',N'براءة الإختراع');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'GoodWill',N'شهرة المحل');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total of intangible assets',N'اجمالي الأصول غير الملموسة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'TOTAL ASSETS',N'إجمالي الأصول (١٣٣٠٠');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Short term notes payable',N'أوراق دفع قصيرة الأجل');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Payables',N'دائنون');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Accrued premium of long-term Loans',N'قسط مستحق من القروض طويلة الأجل');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Payable to related parties',N'قروض قصيرة الأجل ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Short term Loans',N'مستحق لأطراف ذات علاقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total of Current liabalities',N'إجمالي الخصوم المتداولة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Long-term Loans',N'قروض طويلة الأجل ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Long-term notes payable',N'أوراق دفع طويلة الأجل');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Current or the partners',N'جاري الشركاء');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Payable to related parties',N'مستحق لأطراف ذات علاقة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total of non-current liabilities',N'إجمالي الإلتزامات غير المتداولة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Others',N'أخرى');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Total of shareholder''s equity',N'إجمالي حقوق الملكية');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'TOTAL LIABILITIES & SHAREHOLDERS'' EQUITY',N'إجمالي الخصوم وحقوق الشركاء (١٣٦٠٠+١٣٧٠٠+١٣٦٠٠)');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'NON-CURRENT ASSETS',N' متداولة أصول غير');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'CURRENT ASSETS',N'أصول متداولة ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'INTANGIBLE ASSETS',N'ملموسة  أصول غير');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'NON-CURRENT LIABALITIES',N'متداولةخصوم غير');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'CURRENT LIABILITIES',N'خصوم متداولة');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'SHAREHOLDER''S EQUITY',N'حقوق الشركاء');


--FOOTER-----
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Is the weighted average method used for valuation of ending inventory(stock count)?',N'هل يستخدم أسلوب المتوسط المرجح عند تقييم بضاعة آخر المدة (الجرد) ؟');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'specify N/A',N'');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Is the lower of cost or market method is used for valuation of the endimg inventory?',N'هل تمسك الدفاتر النظامية باللغة العربية ؟	');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Are the statutory books maintained in Arabic?',N'هل تمسك الدفاتر النظامية باللغة العربية ؟');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'I declare that this return and          
                           its attachments are prepared per the books and records maintained          
                           by the entity for the fiscal period covered by this return and          
                           i shall be fully responsible in caseit is proven          
                           that the information contained there is incorrect',N'أقر بأنه تم إعداد هذا الإقرار ومرفقاته وفقا للدفــاتر والسجلات التي تحتفظ بها المنشأة وللفترة الماليـة المقدم عنها الإقرار، وأتحمل المسؤولية كاملة عن أية معلومات يثبت عدم صحتها .');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Name:',N'الاسم :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Signature:',N'التوقيع :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Title:',N'الصفة :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'EY Stamp',N'الختم :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Stamp',N'ختم المنشأة :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'I certify that the information recorded in the          
                           return are extracted from the taxpayers books and records          
                           and are in accordance therewith,and that the return          
                           has been prepared according to the  saudi income tax regulations.',N'أشهد بأن المعلومات المدونة بالإقـرار مستخرجة من دفاتر وسجلات المكلف ومطابقــة لها، وأن الإقرار تم إعداده وفقا لأحكام نظام ضريبة الدخل السعودي.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'License No.',N'رقم الترخيص :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Financial No.:',N' الرقم المالي :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Signature:',N'التوقيع :');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'The department enables zakat/tax payers to benfit from the electronic services as per the following terms and conditions*:',N'الشروط و الأحكام');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'This return is for all Saudi and nani-Saudi zakat/taxpayers (establishments and companies) whether residents or non-residents operating through a permanent establishments.',N'١ -  هذا الإقرار خاص بالمكلفين الذين يحاسبون طبقاً للأنظمة واللوائح والتعليمات المعمول بها لدى الهيئة العامة للزكاة والدخل والخاصة بأحكام جباية الزكاة وتحصيل الضريبة. ');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'This return should be completed in Arabic with clear writing without changing the information by blotting, erasing or alteration. if the company has any further clarifications,          
                             these should be enclosed with the declaration.',N'١ -  هذا الإقرار خاص بالمكلفين الذين يحاسبون طبقاً للأنظمة واللوائح والتعليمات المعمول بها لدى الهيئة العامة للزكاة والدخل والخاصة بأحكام جباية الزكاة وتحصيل الضريبة.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'The return shall not be considered reliable unless all of its fields are completed and the required exhbits and attachments are enclosed',N'٣ -  قع عبء إثبات صحة ما ورد في إقرار المكلف من إيرادات ومصروفات وأي بيانات أخرى على المكلف، وفي حال عدم تمكنه من إثبات صحة ما ورد في إقراره، يجوز للهيئة -إضافة إلى إيقاع أي جزاءات نظامية أخرى- عدم إجازة المصروف الذي لا يتم إثبات صحته من قبل المكلف أو القيام بربط تقديري وفقاً لوجهة نظر الهيئة في ضوء الظروف والحقائق المرتبطة بالحالة والمعلومات المتاحة للهيئة.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,' This return and its attachments should be submitted within one hundred and twenty days from the end of the fiscal year          
                             for which the return is prepared, together with the settlement of the zakat/tax payable in accordance therewith.',N'٤ -  يجب ان يتضمن الاقرار المقدم نتائج النشاط الرئيسي والأنشطة الفرعية الاخرى.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Returns of resident Saudi partnerships and joint ventures (Consortiums), wherein one shareholder or more are non-Saudis, 
                             are prepared according to this form. This is considered as a declaration of information and each shareholder should file an independent 
                             return for his entire activities in the Kingdom.',N'٥ -  لا يعتد بالإقرار ما لم تكن حقوله مكتملة مع تعبئة كافة الكشوف والمرفقات المطلوبة.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'In case of non-resident insurance companies operating through Permanent Establishments, the taxble profit is higher          
                             of the adjuststed profit per accounts or profit per the formula referred to in Artical 18 of the executive Bye-laws',N'٦ - يعد الإقرار مقدماً بموجب إشعار رسمي من قبل الهيئة بكل أشكاله سواء الإلكترونية أو الورقية، ويكون السداد بموجبه.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,' If this return is not filed according to the above specified measures and if payable amounts are not          
                             settled accordingly within the statutory time, a fine for non-submission of declaration will be calculated per Article 76 of the Regulations and a delay fine will be calculated at 1%          
                             of the outstanding payable tax, for each thirty days of delay according to Article 77 Para (a) of the Regulations.',N' ٧ - يجب تحديث جميع بيانات الانشطة المملوكة والقائمة وكذلك عنوان المنشاة وبيانات الاتصال قبل تقديم الاقرار');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'The receipts (collections orders) evidencing settlement of amounts payable per the return should be enclosed.',N'٨ - يلزم مصادقة محاسب قانوني على صحة هذا بيانات الإقرار إذا زاد إجمالي الدخل الخاضع للضريبة عن مليون ريال سعودي.	');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'The company and Chartered Accountant assume full responsibility for the correctness of this information which          
                             should correspond to the company statutory bookS and records. However failure to observe accuracy and correctness or advertant concealment          
                             of information will cause the Department to take all necessary actions in this regard which will delay in the          
                             finalization of issuing the certificate.',N'١٠-  إذا كان يتوجب على المكلف زكاة مستحقة خلاف ما جبته المصلحة فيلزم إخراجها بمعرفته إبراءاً للذمة.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'If the zakat/tax payer is liable for zakat other than that levied by the Department, he should pay it on his own to clear his part.',N' ١١ - يحق للمصلحة اعادة احتساب مقدار الزكاة الشرعية والضرائب المستحقة وإشعار المكلف بها في حال توفر بيانات اخرى خلاف ما تم التصريح عنه بالإقرار او بسبب احتسابها بالإقرار بطريقة تخالف الأنظمة واللوائح.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'The Department is entitled to recompute the amount of zakat and tax payable and will notify the zakat/tax payer of such recomputation          
                             if the available information differ from those reported in the return or if they are computed in the return in a method contradicting with the requlations and byelaws.',N'١٢ -  الخدمة الإلكترونية أقر المكلف بمسئوليته الكاملة عن استخدامه الشخصي لنظام الاقرارات وفقا للأغراض والاستخدامات المقررة. وبمسئوليته عن القيام بالعمليات و ذلك بواسطة الخدمات الإلكترونية ، وأي استخدام لتلك الخدمة يقوم به الشخص المفوض من قبله بعلمه أو بدون علمه وذلك باستخدام بيانات الدخول ،. كما أقر المكلف بأن الرقم السري يعتبر بمثابة التوقيع الشخصي أيا كان مستخدم الخدمة. ولا تتحمل المصلحة مطلقا أي أضرار أو نتائج أو خسائر أو تعويضات تترتب على عدم الالتزام بأي مما ذكر. ويكون المكلف مسئولا عن صحة وسلامة ونظامية جميع العمليات التي تتم باستخدام الخدمة.');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,' Electronic service – The tax/zakat payer acknowledged full responsibility for its personal use of the declarations filing system according to the designated
                             purposes and applications and for transactions carried out through the electronic service and for any usage of such service by its authorized representative 
                             with or without its knowledge by using the access information. It also acknowledged that the PIN code represents its personal signature no matter who is the
                             user of the service. The department will never be responsible for any harm, consequences, losses or compensation arising from noncompliance with the above. 
                             The zakat/tax payer shall be responsible for the correctness, safety and legality of all   transactions carried out using this service.',N'١٣ -  المكلف مسئول مسئولية كاملة عن جميع الالتزامات التي تنشأ عن استخدام الخدمة	');
--set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'The zakat/tax payer is fully responsible for all the obligations arising from using the service.',N'');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'*Acknowledgement:I the undersigned,acknowledge that I have read the above mentioned terms & conditions and agree thereto.',N' اقرار:  أقر انا الموقع أدناه بقراءة الاحكام والشروط الموضحة بعالية والموافقة عليه	');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'DECLARATION *
TAX/ZAKAT PAYER''S',N'أقرا المكلـف');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'Accountants
Licensed',N'  شهادة المحاسب القانوني');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'YES',N'نعم');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'NO',N'لا');
set @htmlarabic = [dbo].ReplaceHtmlString(@htmlarabic,'specify N/A',N'حدد لاينطبق...............................');

--select @htmlarabic
--Update CitForm set html=@htmlarabic where Language='ar';
Update CitForm set Pdftemplate=@htmlarabic where Language='ar';

END
GO
