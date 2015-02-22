require_relative '../spec_helper'

class Syllabize::Counter
  public :count_vowels, :ends_in_silent_e?, :count_diphthongs,
         :contains_diphthongs?, :ends_in_sm?, :contains_non_initial_y?,
         :count_ys_in_vowel_role, :contains_le_vowel_sound?,
         :begins_with_re_vowel?, :is_int_in_string_form?
end

describe Syllabize::Counter do

  describe '#count_vowels' do
    let(:word) { 'America' }
    it 'counts the vowels in a word' do
      expect(Syllabize::Counter.new(word).count_vowels).to eql(4)
    end
  end

  describe '#is_int_in_string_form?' do
    subject { Syllabize::Counter.new(word).is_int_in_string_form? }
    context 'is an int' do
      context 'zero' do
        let(:word) { '0' }
        it 'returns true' do
          expect(subject).to be_true
        end
      end
      context 'positive' do
        let(:word) { '500' }
        it 'returns true' do
          expect(subject).to be_true
        end
      end
      context 'negative' do
        let(:word) { '-10' }
        it 'returns true' do
          expect(subject).to be_true
        end
      end
    end
    context 'not an int' do
      let(:word) { 'pizza' }
      it 'returns false' do
        expect(subject).to be_false
      end
    end
  end

  describe '#ends_in_silent_e?' do
    context 'silent e' do
      it 'returns true if the word ends in a silent e' do
        expect(Syllabize::Counter.new('kite').ends_in_silent_e?).to be_true
      end
    end
    context 'not silent e' do
      it 'returns false if the word ends in e but is not silent' do
        expect(Syllabize::Counter.new('now').ends_in_silent_e?).to be_false
      end
    end
  end

  describe '#contains_le_vowel_sound?' do
    context 'does contain' do
      it 'returns true if the word contains -le as a vowel sound' do
        expect(Syllabize::Counter.new('castle').contains_le_vowel_sound?).to be_true
      end
    end
    context 'does not contain' do
      it 'returns false if the word does not contain le vowel' do
        expect(Syllabize::Counter.new('no').contains_le_vowel_sound?).to be_false
      end
    end
  end

  describe '#contains_non_initial_y?' do
    context 'has a y in middle or end of word' do
      it 'returns true if the word ends in y' do
        expect(Syllabize::Counter.new('sticky').contains_non_initial_y?).to be_true
      end
    end
    context 'begins with y' do
      it 'returns false if the word does not end in y' do
        expect(Syllabize::Counter.new('yes').contains_non_initial_y?).to be_false
      end
    end
    context 'does not contain y' do
      it 'returns false if the word does not contain y' do
        expect(Syllabize::Counter.new('please').contains_non_initial_y?).to be_false
      end
    end
  end

  describe '#count_ys_in_vowel_role' do
    context '2 ys in vowel role' do
      it 'returns 2 for ys_in_vowel_role' do
        expect(Syllabize::Counter.new('slyly').count_ys_in_vowel_role).to eq(2)
      end
    end
  end

  describe '#contains_diphthongs' do
    let(:word) { 'ear' }
    it 'returns true if the word contains diphthongs' do
      expect(Syllabize::Counter.new(word).contains_diphthongs?).to be_true
    end
  end

  describe '#begins_with_re_vowel?' do
    it 'returns true if the word begins with re- and a vowel' do
      expect(Syllabize::Counter.new('rearrange').begins_with_re_vowel?).to be_true
      expect(Syllabize::Counter.new('dreary').begins_with_re_vowel?).to be_false
    end
  end

  describe '#count_diphthongs' do
    it 'counts the diphthongs in a word' do
      expect(Syllabize::Counter.new('air').count_diphthongs).to eq(1)
      expect(Syllabize::Counter.new('aerie').count_diphthongs).to eq(2)
    end
  end

  describe '#ends_in_sm?' do
    it 'returns true if the word ends in -sm' do
      expect(Syllabize::Counter.new('communism').ends_in_sm?).to be_true
    end
  end

  describe '#count_syllables' do
    context 'given a string' do
      it 'counts the syllables in a word' do
        {
          'blizzard'          => 2,
          'why'               => 1,
          'plain'             => 1,
          'sticky'            => 2,
          'syzygy'            => 3,
          'yeses'             => 2,
          'communism'         => 4,
          'please'            => 1,
          'candle'            => 2,
          'handling'          => 3,
          'realize'           => 3,
          'really'            => 2,
          'cooperate'         => 4,
          'ways'              => 1,
          "Wayne's"           => 1,
          'basement'          => 2,
          'coach'             => 1,
          'five'              => 1,
          'hundred'           => 2,
          'I really think so' => 5,
          '500'               => 3,
          '1,000,000'         => 3,
          'Anne of'           => 2,
          'purely'            => 2,
          'menacingly'        => 4,
        }.each do |word, actual|
          count = Syllabize::Counter.new(word).count_syllables
          expect(count).to eq(actual), "'#{word}' was not the correct number of syllables; expected #{actual}, was #{count}"
        end
      end

      context 'with suffix /ed/' do
        context '/ed/ is after /t/, /d/, /tr/, /tl/, /dr/, /dl/' do
          it 'counts /ed/ as a syllable' do
            expect(Syllabize::Counter.new('herded').count_syllables).to eq(2)
            expect(Syllabize::Counter.new('carted').count_syllables).to eq(2)
            expect(Syllabize::Counter.new('hundred').count_syllables).to eq(2)
            expect(Syllabize::Counter.new('hatred').count_syllables).to eq(2)
          end
        end
        context '/ed/ is after sounds unrelated to /t/ and /d/' do
          it 'does not count /ed/ as a syllable' do
            expect(Syllabize::Counter.new('worked').count_syllables).to eq(1)
            expect(Syllabize::Counter.new('flapped').count_syllables).to eq(1)
            expect(Syllabize::Counter.new('sneered').count_syllables).to eq(1)
          end
        end
        context '/ed/ is the only syllable of a word' do
          it 'it does count /ed/ as a syllable' do
            expect(Syllabize::Counter.new('bed').count_syllables).to eq(1)
          end
        end
      end
    end
    context 'other data' do
      it 'raises an error' do
        expect { Syllabize::Counter.new(7) }.to raise_error
      end
    end
  end

  describe 'string method' do
    subject { 'hello'.count_syllables }
    it { should == 2 }
  end
end
