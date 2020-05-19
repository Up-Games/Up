//
//  UPSpellGameModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPMacros.h>
#import <UpKit/UPTile.h>
#import <UpKit/UPTileTray.h>

#if __cplusplus

#import <vector>

namespace UP {

class SpellGameModel {
public:
    enum class Opcode: uint8_t {
        NOP,    // no-op
        TAP,    // tap a tile, moving it from the player tray to the word tray
        PICK,   // long press or swipe a tile to pick it up
        DROP,   // drop a picked-up tile, leaving it where it was
        MOVE,   // move a picked-up tile to a new position
        SUBMIT, // tap the word tray to submit a word
        CLEAR,  // tap the clear button to return all tiles to their positions in the player tray
        DUMP,   // tap the dump button to get a new set of tiles
        QUIT    // quit the game
    };

    enum class Position: uint8_t {
        XX,
        P1, P2, P3, P4, P5, P6, P7,
        W1, W2, W3, W4, W5, W6, W7
    };

    class Action {
    public:
        Action() {}
        Action(CFTimeInterval timestamp, Opcode opcode, Position pos1, Position pos2) :
            m_timestamp(timestamp), m_opcode(opcode), m_pos1(pos1), m_pos2(pos2) {}

        CFTimeInterval timestamp() const { return m_timestamp; }
        Opcode opcode() const { return m_opcode; }
        Position pos1() const { return m_pos1; }
        Position pos2() const { return m_pos2; }

    private:
        CFTimeInterval m_timestamp = 0;
        Opcode m_opcode = Opcode::NOP;
        Position m_pos1 = Position::XX;
        Position m_pos2 = Position::XX;
    };

    void add_action(CFTimeInterval timestamp, Opcode opcode, Position pos1, Position pos2) {
        m_actions.emplace_back(timestamp, opcode, pos1, pos2);
    }

    const std::vector<Action> &actions() const { return m_actions; }

private:
    std::vector<Action> m_actions;
};

}  // namespace UP

#endif  // __cplusplus
