#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <set>
#include <string>
#include <vector>

using namespace std;

int main() {
  srand(time(nullptr));

  vector<string> consonants{"",  "m", "n",  "ng", "p",  "b",  "t",  "d",
                            "ŧ", "đ", "k",  "g",  "f",  "v",  "þ",  "ð",
                            "s", "z", "sh", "zh", "ch", "jh", "qh", "rh",
                            "h", "ŕ", "r",  "lh", "l"};
  const vector<string> glides{"j", "w"};
  vector<string> vowels{"i", "y", "u", "ì", "ĩ", "ů", "ù", "ũ", "e", "é", "ø",
                        "ö", "o", "õ", "è", "œ", "ô", "ò", "a", "å", "ã"};
  const vector<string> tones{"2", "3", "4", "5", "6", "7"};
  {
    const auto tmp = consonants;
    for_each(begin(tmp), end(tmp), [&](const auto &cons) {
      for_each(begin(glides), end(glides),
               [&](const auto &glide) { consonants.push_back(cons + glide); });
    });
  }
  {
    const auto tmp = vowels;
    // create each possible diphthong
    for_each(begin(tmp), end(tmp), [&](const auto &vow1) {
      // add tones for this vowel
      std::for_each(std::begin(tones), std::end(tones),
                    [&](const auto &tone) { vowels.push_back(vow1 + tone); });
      for_each(begin(tmp), end(tmp), [&](const auto &vow2) {
        if (vow1 != vow2) {
          // if both vowels are the same, their association is ignored
          const auto new_vow = vow1 + vow2;
          vowels.push_back(new_vow);
          // add tones to these vowels
          for_each(begin(tones), end(tones),
                   [&](const auto &tone) { vowels.push_back(new_vow + tone); });
        }
      });
    });
  }
  auto all_phonemes = vowels;
  for_each(begin(consonants), end(consonants), [&](const auto &cons) {
    for_each(begin(vowels), end(vowels),
             [&](const auto &vow) { all_phonemes.push_back(cons + vow); });
  });
  all_phonemes.shrink_to_fit();
  printf("%zu syllables\n", all_phonemes.size());
  set<string> particules = {};
  for (auto i = 0; i < 10000; ++i) {
    int random = rand() % all_phonemes.size();
    printf("%s\n", all_phonemes[random].c_str());
    all_phonemes.erase(all_phonemes.begin() + random);
  }
  std::for_each(std::begin(particules), std::end(particules),
                [](const auto &elem) { printf("%s\n", elem.c_str()); });

  return 0;
}
