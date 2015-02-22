require 'yaml'
require 'numbers_and_words'

module Syllabize

  class Counter
    attr_accessor :str, :exceptions_file

    def initialize(str)
      @str = strip_punctuation(str)
      handle_non_string_input
      load_exceptions
      @syllables = 0
    end

    CONSONANTS = /[bcdfghjklmnpqrstvwxz]/i
    VOWELS = /[aeiou]/i
    LE_VOWEL_SOUND = /((le)\z)|((le(d|r|s))|(ling)\z)/i
    DIPHTHONGS = /ou|ie|io|oa|oo|oi|ea|ee|ai|ae|ay/i
    Y_AS_VOWEL = /[^yY][yY]/
    RE_VOWEL = /(^re[aeiou])/i
    SUFFIXES = /(?<=.)(able|ible|al|ial|ed|en|er|est|ful|ic|ing|ion|ing|less|ly|ment|nes|ous)\z/

    def count_syllables
      @str = str.to_i.to_words if is_int_in_string_form?
      return break_into_words  if str.split(' ').length > 1
      return handle_exceptions if exceptions.keys.include?(str)
      count_suffixes if str.scan(SUFFIXES).any?
      @syllables += count_vowels
      handle_additions
      handle_subtractions
      @syllables <= 1 ? 1 : @syllables
    end

    private

    def count_suffixes
      @syllables -= 1 if ends_in_non_syllablic_ed?
      while str.scan(SUFFIXES).any?
        suffix = str.scan(SUFFIXES).flatten.last
        str.sub! /(?<=.)#{suffix}/, ''
        @syllables += 1
      end
    end

    def break_into_words
      str.split(' ').collect(&:count_syllables).reduce(:+)
    end

    def strip_punctuation(string)
      string.gsub(/[[:punct:]]/,'')
    end

    def is_int_in_string_form?
      str_as_int = str.to_i
      if str_as_int.zero?
        return str == '0' ? true : false
      end
      (str_as_int * str_as_int) > 0 ? true : false
    end

    def handle_non_string_input
      if !(str.is_a?(String))
        raise ArgumentError.new "#{str} must be a string"
      end
    end

    def load_exceptions
      @exceptions_file = YAML::load_file(File.join(__dir__, 'exceptions.yml'))
    end

    def exceptions
      @exceptions_file['exceptions']
    end

    def handle_exceptions
      exceptions[str]
    end

    def handle_additions
      @syllables += count_ys_in_vowel_role if contains_non_initial_y?
      if contains_le_vowel_sound? || begins_with_re_vowel? || ends_in_sm?
        @syllables += 1
      end
    end

    def handle_subtractions
      @syllables -= 1 if ends_in_silent_e?
      @syllables -= count_diphthongs if contains_diphthongs?
    end

    def count_vowels
      str.scan(VOWELS).count
    end

    def ends_in_silent_e?
      str.end_with?('e')
    end

    def contains_le_vowel_sound?
      str.scan(LE_VOWEL_SOUND).any?
    end

    def contains_non_initial_y?
      count_ys_in_vowel_role > 0
    end

    def count_ys_in_vowel_role
      str.scan(Y_AS_VOWEL).size
    end

    def begins_with_re_vowel?
      str.scan(RE_VOWEL).any?
    end

    def contains_diphthongs?
      str.downcase.scan(DIPHTHONGS).any?
    end

    def count_diphthongs
      str.downcase.scan(DIPHTHONGS).count
    end

    def ends_in_sm?
      str.end_with?('sm')
    end

    def has_more_than_one_syllable?
      (count_vowels - count_diphthongs) > 1
    end

    def ends_in_ed?
      str.end_with?('ed')
    end

    def ending_ed_is_not_syllablic?
      str.scan(/(t|d|tr|dr|tl|dl)ed\b/).empty?
    end

    def ends_in_non_syllablic_ed?
      if has_more_than_one_syllable? && ends_in_ed? && ending_ed_is_not_syllablic?
        true
      else
        false
      end
    end

    # for Ruby 1.9
    def __dir__
      File.dirname(__FILE__)
    end unless respond_to?(:__dir__, true)
  end

end

class String
  def count_syllables
    Syllabize::Counter.new(self).count_syllables
  end
end
