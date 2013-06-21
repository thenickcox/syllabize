require_relative '../spec_helper'

class Syllabize::Counter
  public :count_vowels, :ends_in_silent_e?, :count_diphthongs,
         :contains_diphthongs?, :ends_in_y?
end

describe Syllabize::Counter do

  describe '#count_vowels' do
    let(:word) { 'America' }
    it 'counts the vowels in a word' do
      expect(Syllabize::Counter.new(word).count_vowels).to eql(4)
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
        expect(Syllabize::Counter.new('tickle').ends_in_silent_e?).to be_false
      end
    end
  end

  describe '#ends_in_y?' do
    context 'ends in y' do
      it 'returns true if the word ends in y' do
        expect(Syllabize::Counter.new('sticky').ends_in_y?).to be_true
      end
    end
    context 'does not end in y' do
      it 'returns false if the word does not end in y' do
        expect(Syllabize::Counter.new('yes').ends_in_y?).to be_false
      end
    end
  end

  describe '#contains_diphthongs' do
    let(:word) { 'ear' }
    it 'returns true if the word contains diphthongs' do
      expect(Syllabize::Counter.new(word).contains_diphthongs?).to be_true
    end
  end

  describe '#count_diphthongs' do
    it 'counts the diphthongs in a word' do
      expect(Syllabize::Counter.new('air').count_diphthongs).to eq(1) 
      expect(Syllabize::Counter.new('aerie').count_diphthongs).to eq(2) 
    end
  end

  describe '#count_syllables' do
    it 'counts the syllables in a word' do
      expect(Syllabize::Counter.new('blizzard').count_syllables).to eq(2)
      expect(Syllabize::Counter.new('why').count_syllables).to eq(1)
      expect(Syllabize::Counter.new('plain').count_syllables).to eq(1)
      expect(Syllabize::Counter.new('sticky').count_syllables).to eq(2)
    end
  end

end
