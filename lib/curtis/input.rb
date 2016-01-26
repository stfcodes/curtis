module Curtis
  module Input

    MAX_CHAR = 255
    ENTER = 13
    ESCAPE = 27
    A_TO_Z = ('a'..'z').to_a.freeze

    module_function

    def get
      return translate_key(Ncurses.getch) unless block_given?

      while key = translate_key(Ncurses.getch)
        yield key
      end
    end

    # https://github.com/grosser/dispel/blob/master/lib/dispel/keyboard.rb
    def translate_key(key)
      case key
      # Movement
      when Ncurses::KEY_UP      then :up
      when Ncurses::KEY_DOWN    then :down
      when Ncurses::KEY_RIGHT   then :right
      when Ncurses::KEY_LEFT    then :left
      when Ncurses::KEY_END     then :end
      when Ncurses::KEY_HOME    then :home
      when Ncurses::KEY_NPAGE   then :page_down
      when Ncurses::KEY_PPAGE   then :page_up

      # Code, Unix, iTerm
      when 337, '^[1;2A', "^[A" then :shift_up
      when 336, '^[1;2B', "^[B" then :shift_down
      when 402, '^[1;2C'        then :shift_right
      when 393, '^[1;2D'        then :shift_left
      when 558, '^[1;3A'        then :alt_up
      when 517, '^[1;3B'        then :alt_down
      when 552, '^[1;3C'        then :alt_right
      when 537, '^[1;3D'        then :alt_left
      when 560, '^[1;5A'        then :ctrl_up
      when 519, '^[1;5B'        then :ctrl_down
      when 554, '^[1;5C'        then :ctrl_right
      when 539, '^[1;5D'        then :ctrl_left
      when 561, '^[1;6A'        then :ctrl_shift_up
      when 520, '^[1;6B'        then :ctrl_shift_down
      when 555, '^[1;6C', "^[C" then :ctrl_shift_right
      when 540, '^[1;6D', "^[D" then :ctrl_shift_left
      when 562, '^[1;7A'        then :alt_ctrl_up
      when 521, '^[1;7B'        then :alt_ctrl_down
      when 556, '^[1;7C'        then :alt_ctrl_right
      when 541, '^[1;7D'        then :alt_ctrl_left
      when      '^[1;8A'        then :alt_ctrl_shift_up
      when      '^[1;8B'        then :alt_ctrl_shift_down
      when      '^[1;8C'        then :alt_ctrl_shift_right
      when      '^[1;8D'        then :alt_ctrl_shift_left
      when      '^[1;10A'       then :alt_shift_up
      when      '^[1;10B'       then :alt_shift_down
      when      '^[1;10C'       then :alt_shift_right
      when      '^[1;10D'       then :alt_shift_left
      when      '^[F'           then :shift_end
      when      '^[H'           then :shift_home
      when      '^[1;9F'        then :alt_end
      when      '^[1;9H'        then :alt_home
      when      '^[1;10F'       then :alt_shift_end
      when      '^[1;10H'       then :alt_shift_home
      when      '^[1;13F'       then :alt_ctrl_end
      when      '^[1;13H'       then :alt_ctrl_home
      when      '^[1;14F'       then :alt_ctrl_shift_end
      when      '^[1;14H'       then :alt_ctrl_shift_home
      when 527                  then :ctrl_shift_end
      when 532                  then :ctrl_shift_home

      when Ncurses::KEY_IC      then :insert
      when Ncurses::KEY_F0..Ncurses::KEY_F30 then :"f#{key - Ncurses::KEY_F0}"

      # Modify
      when 9        then :tab
      when 353      then :shift_tab
      when ENTER    then :enter # shadows Ctrl_m
      when 263, 127 then :backspace
      when '^[3~', Ncurses::KEY_DC then :delete

      # Misc
      when 0        then :ctrl_space
      when 1..26    then :"ctrl_#{A_TO_Z[key - 1]}"
      when ESCAPE   then :escape
      when Ncurses::KEY_RESIZE then :resize

      else
        if key.is_a? Fixnum
          key > MAX_CHAR ? key : key.chr
        elsif alt_key_code?(key)
          :"alt_#{key[1]}"
        else
          key
        end
      end
    end

    def alt_key_code?(sequence)
      sequence.size == 2 && sequence.starts_with?('^')
    end
  end
end
