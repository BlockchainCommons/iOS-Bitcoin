import Foundation

public struct SplitRecoveryPhrase {
    static let bitsPerWord = 10
    static let checkWordsCount = 3

    public static func generateEntropy(wordCount: Int) -> Data {
        let entropyBits = wordCount * bitsPerWord
        return seed(bits: entropyBits)
    }

    public static func makeRecoveryPhrase(from data: Data, wordCount: Int) -> String {
        let bitEnumerator = BitEnumerator(data: data)
        let indexes = (0 ..< wordCount).map { _ in
            return Int(bitEnumerator.nextUInt10()!)
        }
        var words = indexes.map { slip39Words[$0] }
        let checkIndexes = createChecksum(indexes)
        let checkWords = checkIndexes.map { slip39Words[$0] }
        words.append(contentsOf: checkWords)
        return words.joined(separator: " ")
    }

    public static func makeData(from phrase: String) throws -> Data {
        let words = phrase.split(separator: " ").map { String($0) }
        guard words.count > checkWordsCount else {
            throw BitcoinError.invalidData
        }
        let indexes = try words.map { word -> Int in
            guard let index = slip39IndexesByWord[word] else {
                throw BitcoinError.invalidData
            }
            return index
        }
        let checkStartIndex = indexes.count - checkWordsCount
        let dataIndexes = Array(indexes[0 ..< checkStartIndex])
        guard verifyChecksum(indexes) else {
            throw BitcoinError.invalidData
        }
        var bitAggregator = BitAggregator()
        for index in dataIndexes {
            bitAggregator.append(from: index, count: 10)
        }
        return bitAggregator.data
    }

    public static func generateRecoveryPhrase(wordCount: Int = 13) -> String {
        let entropy = generateEntropy(wordCount: wordCount)
        return makeRecoveryPhrase(from: entropy, wordCount: wordCount)
    }

    //    def rs1024_polymod(values):
    //      GEN = [0xe0e040, 0x1c1c080, 0x3838100, 0x7070200, 0xe0e0009, 0x1c0c2412, 0x38086c24, 0x3090fc48, 0x21b1f890, 0x3f3f120]
    //      chk = 1
    //      for v in values:
    //        b = (chk >> 20)
    //        chk = (chk & 0xfffff) << 10 ^ v
    //        for i in range(10):
    //          chk ^= GEN[i] if ((b >> i) & 1) else 0
    //      return chk
    
    static func rs1024Polymod(_ values: [Int]) -> Int {
        let GEN = [0xe0e040, 0x1c1c080, 0x3838100, 0x7070200, 0xe0e0009, 0x1c0c2412, 0x38086c24, 0x3090fc48, 0x21b1f890, 0x3f3f120]
        var chk = 1
        for v in values {
            let b = chk >> 20
            chk = ((chk & 0xfffff) << 10) ^ v
            for i in 0 ..< 10 {
                if ((b >> i) & 1) != 0 {
                    chk ^= GEN[i]
                }
            }
        }
        return chk
    }

    //    def rs1024_verify_checksum(cs, data):
    //      return rs1024_polymod([ord(x) for x in cs] + data) == 1

    static func verifyChecksum(_ values: [Int]) -> Bool {
        return rs1024Polymod(values) == 1
    }

    //    def rs1024_create_checksum(cs, data):
    //      values = [ord(x) for x in cs] + data
    //      polymod = rs1024_polymod(values + [0,0,0]) ^ 1
    //      return [(polymod >> 10 * (2 - i)) & 1023 for i in range(3)]

    static func createChecksum(_ values: [Int]) -> [Int] {
        let polymod = rs1024Polymod(values + [0, 0, 0]) ^ 1
        return (0 ..< checkWordsCount).map { i in
            return (polymod >> (10 * (2 - i))) & 1023
        }
    }
    
    /// https://github.com/satoshilabs/slips/blob/master/slip-0039/wordlist.txt
    static let slip39Words = "academic acid acoustic actor actress adapt adjust admit adult advance advice aerobic afraid again agent agree airport aisle alarm album alcohol alert alien alpha already also alter always amazing amount amused analyst anchor anger angry animal answer antenna antique anxiety anything apart april arctic arena argue armed armor army artefact artist artwork aspect atom auction august aunt average avocado avoid awake away awesome awful awkward axis bean beauty because become bedroom behave believe below bench benefit best betray between beyond bicycle bike biology bird birth black blame blanket bleak blind blossom boat body bomb border bounce bowl bracket brain brand brave bread bridge brief broccoli broken brother brown brush budget build bulb burden burger burn busy buyer cactus camera campaign canal canyon capital captain carbon career carpet casino castle catalog catch category cause ceiling cement census chair chaos chat cheap check choice chuckle churn circle city civil claim clap clarify clean clerk clever click client climb clinic clog closet cloth clown club clump cluster coach coconut code coil column comfort comic coral corn cost country cousin cover coyote cradle craft crane crater crazy credit crew cricket crime crisp critic cross crouch crowd crucial cruel cruise crunch crystal cube culture cupboard curious curve cycle daily damage dance daughter death debris decade december decision decline decorate decrease degree delay deliver denial dentist deny depart depend describe desert design desk despair destroy detail detect device devote diamond diary diesel diet dilemma direct disagree dismiss display distance divert divorce doctor dolphin domain dose double dozen dragon drama drastic dream dress drift drink drum duck dumb dune dwarf dynamic eager eagle early earn earth easy echo ecology edge edit educate elbow elder electric elegant element elephant elevator elite else embrace emerge employ empty endless endorse enemy energy enforce engage enjoy enlist enroll entire entry envelope episode equal erase erode erosion erupt escape estate eternal event evidence evil evolve exact example excess exchange exclude excuse execute exercise exhaust exile exist exotic expand expect expire explain express extend extra eyebrow face facility faculty faint faith false family famous fancy fantasy fashion fatal fatigue favorite fiber fiction field file filter final find finish firm fiscal fish fitness flag flavor flip float flower fluid foam focus fold force forest forget fork fortune forward fragile frame frequent fresh friend fringe frog frozen fruit fuel function furnace fury gadget galaxy garden garlic gasp gate gauge general genius genre gentle gesture glad glance glare glide glimpse glue goal golden grape grass gravity great grid grocery group grow grunt guard guess guilt guitar half hamster hand harbor harvest hawk hazard head heart heavy hedgehog help hero hockey holiday hospital hotel hour huge human hundred hurdle hurt husband hybrid idea identify idle image imitate impact improve impulse inch income increase index industry infant inflict inform inhale inherit injury inmate insane insect inside install intact invite involve island isolate item ivory jacket jaguar jealous jeans jewel join joke judge juice jump jungle junk ketchup kick kingdom kitchen kite kiwi knife lady lamp large laugh laundry lava lawn lawsuit layer leader leaf league leave lecture legal legend leisure lemon length lens level liberty library license lift likely limit line living lizard loan lobster local lock loud love lucky lunar lunch luxury lyrics machine magazine magnet maid make manage mandate mango mansion manual maple marble march mask master material matrix maximum meaning measure media melt member menu mercy mesh metal method midnight minute miracle misery mistake mixed mixture mobile model modify moment more morning motor mouse movie much mule multiply muscle museum music must myself mystery myth naive name napkin neck negative neglect neither nephew nerve network news nice nuclear number obey object oblige obscure obtain ocean october odor often olive olympic orange orbit ordinary organ orient ostrich other oven owner oyster package pact painting pair palace panda panic panther paper parade parent park party path patrol pave payment peace peanut peasant pelican penalty pencil perfect period permit photo phrase physical piano picnic picture piece pilot pink pipe pistol pitch planet plastic plate play please pledge pluck plug plunge practice predict prepare present pretty primary priority prison private prize problem produce profit program promote prosper proud public pulse pumpkin pupil purchase purpose push pyramid quantum quarter question quick quiz quote rack radar radio raise ranch rapid rare raven razor ready real rebel recall receive recipe recycle regret regular reject relax rely remind remove render repair repeat replace rescue resemble resist response retreat reunion review reward rhythm rich rifle ring risk rival river road robot robust rocket romance rotate rough royal rude runway rural sadness salad salon salt satisfy satoshi sauce sausage scale scan scatter scene school science scissors scorpion scout scrap screen script scrub search seat second secret security segment select senior sense sentence service seven shadow shaft share shed sheriff shock shoe short shoulder shrimp sibling siege silent silver similar simple siren sister size skate sketch skin skirt skull slender slice slogan slow slush small smart smile smoke snake social soda soft soldier solve someone soul sound source spawn special spell spend sphere spider spike spirit split spray spread spring squeeze stadium staff stage stamp stand station stay steak step stereo stick still sting stomach stove strike strong style sugar suit sunset super surface survey swallow swap swear swift swim switch sword symbol symptom system tackle tail talent target taxi teach team tenant text thank theater theme theory throw thunder ticket tilt timber time tiny tired title toast today together toilet token tomato torch tornado tortoise total tourist tower town trade traffic transfer trash travel tray trend trial trick trim trouble true trumpet trust twelve twenty twice twin twist type typical ugly umbrella unaware uncle uncover under unfair unfold unhappy unique universe unknown until upgrade upset urge usage used useless usual vacant vacuum vague valid valve vanish vast vault velvet vendor venture verify very veteran vibrant vicious victory video view vintage violin virus visa visit vital vivid voice volcano volume vote voyage wage wagon wait walnut warfare warm warning wash waste water wealth weapon weather weird welcome western whale wheat when where width wild window winter wire wisdom wolf woman world worth wrap wreck wrestle wrist write yard young zebra".components(separatedBy: " ")

    static let slip39IndexesByWord: [String: Int] = slip39Words.enumerated().reduce(into: [String: Int]()) { (dict, indexWord) in
        let (index, word) = indexWord
        dict[word] = index
    }

    struct BitAggregator {
        private typealias `Self` = BitAggregator

        public private(set) var data: Data
        private var bitMask: UInt8

        init() {
            data = Data(count: 0)
            bitMask = 0
        }

        mutating func append(bit: Bool) {
            if bitMask == 0 {
                bitMask = 0x80
                data.append(0)
            }
            if bit {
                data[data.count - 1] = data[data.count - 1] | bitMask
            }
            bitMask >>= 1
        }

        private static func bitValue(of value: Int, at index: Int) -> Bool {
            let mask = 1 << index
            let value = value & mask
            return value != 0
        }

        mutating func append(from value: Int, count: Int) {
            for index in (0..<count).reversed() {
                append(bit: Self.bitValue(of: value, at: index))
            }
        }
    }

    final class BitEnumerator: Sequence, IteratorProtocol {
        private let data: Data
        private var byteIndex: Int
        private var bitMask: UInt8

        init(data: Data) {
            self.data = data
            byteIndex = 0
            bitMask = 0x80
        }

        func next() -> Bool? {
            guard byteIndex < data.count else { return nil }
            let result = (data[byteIndex] & bitMask) != 0
            bitMask >>= 1
            if bitMask == 0 {
                bitMask = 0x80
                byteIndex += 1
            }
            return result
        }

        func nextUInt2() -> UInt8? {
            var bitMask: UInt8 = 0x02
            var value: UInt8 = 0
            for _ in 0 ..< 2 {
                guard let b = next() else {
                    return nil
                }
                if b {
                    value |= bitMask
                }
                bitMask >>= 1
            }
            return value
        }

        func nextUInt8() -> UInt8? {
            var bitMask: UInt8 = 0x80
            var value: UInt8 = 0
            for _ in 0 ..< 8 {
                guard let b = next() else {
                    return nil
                }
                if b {
                    value |= bitMask
                }
                bitMask >>= 1
            }
            return value
        }

        func nextUInt10() -> UInt16? {
            var bitMask: UInt16 = 0x0200
            var value: UInt16 = 0
            for _ in 0 ..< 10 {
                guard let b = next() else {
                    return nil
                }
                if b {
                    value |= bitMask
                }
                bitMask >>= 1
            }
            return value
        }

        func nextUInt16() -> UInt16? {
            var bitMask: UInt16 = 0x8000
            var value: UInt16 = 0
            for _ in 0 ..< 16 {
                guard let b = next() else {
                    return nil
                }
                if b {
                    value |= bitMask
                }
                bitMask >>= 1
            }
            return value
        }
    }
}
