require 'spec_helper'

RSpec.describe PragmaticSegmenter::Languages::Japanese, "(ja)" do

  context "Golden Rules" do
    it "Simple period to end sentence #001" do
      ps = PragmaticSegmenter::Segmenter.new(text: "これはペンです。それはマーカーです。", language: "ja")
      expect(ps.segment).to eq(["これはペンです。", "それはマーカーです。"])
    end

    it "Question mark to end sentence #002" do
      ps = PragmaticSegmenter::Segmenter.new(text: "それは何ですか？ペンですか？", language: "ja")
      expect(ps.segment).to eq(["それは何ですか？", "ペンですか？"])
    end

    it "Exclamation point to end sentence #003" do
      ps = PragmaticSegmenter::Segmenter.new(text: "良かったね！すごい！", language: "ja")
      expect(ps.segment).to eq(["良かったね！", "すごい！"])
    end

    it "Quotation #004" do
      ps = PragmaticSegmenter::Segmenter.new(text: "自民党税制調査会の幹部は、「引き下げ幅は３．２９％以上を目指すことになる」と指摘していて、今後、公明党と合意したうえで、３０日に決定する与党税制改正大綱に盛り込むことにしています。２％台後半を目指すとする方向で最終調整に入りました。", language: "ja")
      expect(ps.segment).to eq(["自民党税制調査会の幹部は、「引き下げ幅は３．２９％以上を目指すことになる」と指摘していて、今後、公明党と合意したうえで、３０日に決定する与党税制改正大綱に盛り込むことにしています。", "２％台後半を目指すとする方向で最終調整に入りました。"])
    end

    it "Errant newlines in the middle of sentences #005" do
      ps = PragmaticSegmenter::Segmenter.new(text: "これは父の\n家です。", language: "ja")
      expect(ps.segment).to eq(["これは父の家です。"])
    end
  end

  describe '#segment' do
    it 'correctly segments text #001' do
      ps = PragmaticSegmenter::Segmenter.new(text: "これは山です \nこれは山です \nこれは山です（「これは山です」） \nこれは山です（これは山です「これは山です」）これは山です・これは山です、これは山です。 \nこれは山です（これは山です。これは山です）。これは山です、これは山です、これは山です、これは山です（これは山です。これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です。 \n1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です。 \n※1　これは山です。 \n2.）これは山です、これは山です、これは山です、これは山です。 \n3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です。 \n4.）これは山です、これは山です（これは山です、これは山です、これは山です。これは山です）これは山です、これは山です（これは山です、これは山です）。 \nこれは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です。 \n(1) 「これは山です」（これは山です：0円）　（※1） \n① これは山です", language: 'ja')
      expect(ps.segment).to eq(["これは山です", "これは山です", "これは山です（「これは山です」）", "これは山です（これは山です「これは山です」）これは山です・これは山です、これは山です。", "これは山です（これは山です。これは山です）。", "これは山です、これは山です、これは山です、これは山です（これは山です。これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です。", "1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です。", "※1　これは山です。", "2.）これは山です、これは山です、これは山です、これは山です。", "3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です。", "4.）これは山です、これは山です（これは山です、これは山です、これは山です。これは山です）これは山です、これは山です（これは山です、これは山です）。", "これは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です。", "(1) 「これは山です」（これは山です：0円）　（※1）", "① これは山です"])
    end

    it 'correctly segments text #002' do
      ps = PragmaticSegmenter::Segmenter.new(text: "フフーの\n主たる債務", language: 'ja')
      expect(ps.segment).to eq(["フフーの主たる債務"])
    end

    it 'correctly segments text #003' do
      ps = PragmaticSegmenter::Segmenter.new(text: "これは山です \nこれは山です \nこれは山です（「これは山です」） \nこれは山です（これは山です「これは山です」）これは山です・これは山です、これは山です． \nこれは山です（これは山です．これは山です）．これは山です、これは山です、これは山です、これは山です（これは山です．これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です． \n1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です． \n※1　これは山です． \n2.）これは山です、これは山です、これは山です、これは山です． \n3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です． \n4.）これは山です、これは山です（これは山です、これは山です、これは山です．これは山です）これは山です、これは山です（これは山です、これは山です）． \nこれは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です． \n(1) 「これは山です」（これは山です：0円）　（※1） \n① これは山です", language: 'ja')
      expect(ps.segment).to eq(["これは山です", "これは山です", "これは山です（「これは山です」）", "これは山です（これは山です「これは山です」）これは山です・これは山です、これは山です．", "これは山です（これは山です．これは山です）．", "これは山です、これは山です、これは山です、これは山です（これは山です．これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です．", "1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です．", "※1　これは山です．", "2.）これは山です、これは山です、これは山です、これは山です．", "3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です．", "4.）これは山です、これは山です（これは山です、これは山です、これは山です．これは山です）これは山です、これは山です（これは山です、これは山です）．", "これは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です．", "(1) 「これは山です」（これは山です：0円）　（※1）", "① これは山です"])
    end

    it 'correctly segments text #004' do
      ps = PragmaticSegmenter::Segmenter.new(text: "これは山です \nこれは山です \nこれは山です（「これは山です」） \nこれは山です（これは山です「これは山です」）これは山です・これは山です、これは山です！ \nこれは山です（これは山です！これは山です）！これは山です、これは山です、これは山です、これは山です（これは山です！これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です！ \n1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です！ \n※1　これは山です！ \n2.）これは山です、これは山です、これは山です、これは山です！ \n3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です！ \n4.）これは山です、これは山です（これは山です、これは山です、これは山です！これは山です）これは山です、これは山です（これは山です、これは山です）！ \nこれは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です！ \n(1) 「これは山です」（これは山です：0円）　（※1） \n① これは山です", language: 'ja')
      expect(ps.segment).to eq(["これは山です", "これは山です", "これは山です（「これは山です」）", "これは山です（これは山です「これは山です」）これは山です・これは山です、これは山です！", "これは山です（これは山です！これは山です）！", "これは山です、これは山です、これは山です、これは山です（これは山です！これは山です）これは山です、これは山です、これは山です「これは山です」これは山です（これは山です：0円）これは山です！", "1.）これは山です、これは山です（これは山です、これは山です6円（※1））これは山です！", "※1　これは山です！", "2.）これは山です、これは山です、これは山です、これは山です！", "3.）これは山です、これは山です・これは山です、これは山です、これは山です、これは山です（これは山です「これは山です」）これは山です、これは山です、これは山です、これは山です！", "4.）これは山です、これは山です（これは山です、これは山です、これは山です！これは山です）これは山です、これは山です（これは山です、これは山です）！", "これは山です、これは山です、これは山です、これは山です、これは山です（者）これは山です！", "(1) 「これは山です」（これは山です：0円）　（※1）", "① これは山です"])
    end
  end
end