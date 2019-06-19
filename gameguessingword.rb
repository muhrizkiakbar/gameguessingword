class GameGuessingWord
    @@guesses={}
    @@index=0
    @@level=0
    @@score=0.0.to_f
    @@all_levels_guesses={}
end


class Guess < GameGuessingWord

    #untuk memvalidasi setter guess, karna setiap level memiliki tingkat kesulitan masing2
    def self.validation_setter_guess(level,params)
        begin
            case level
            when 0 then
                if (params.split(" ").length != 1)
                    puts "Level 1, tebakan wajib menggunakan 1 kalimat."
                    raise 'break'
                end
            when 1 then
                if (params.split(" ").length != 2)
                    puts "Level 2, tebakan wajib menggunakan 2 kalimat."
                    raise 'break'
                end
            when 2 then
                if (params.split(" ").length != 3)
                    puts "Level 3, tebakan wajib menggunakan 3 kalimat."
                    raise 'break'
                end
            else
                raise 'break'                
            end
        rescue
            puts "Baca rule terlebih dahulu :)"
            gets.chomp()
            exit
        end
    end

    #penambahan hash index untuk leveling
    def self.add_level(params)
        @@all_levels_guesses[@@level]=params
    end

    #penambahan guess berdasarkan index beserta clue nya
    def self.add_guess(index,guess,clue)

        shuffle_guess= shuffle_params(guess)

        data_guess={}
        data_guess[:guess]=guess
        data_guess[:shuffle_guess]=shuffle_guess
        data_guess[:clue]=clue
        
        array_guess=[data_guess]

        @@guesses[@@index] = array_guess

    end

    private
    
    #untuk mengacak kata
    def self.shuffle_params(guess)

        after_shuffle=""
       
        case guess.split(" ").length
        when 2..4 then
            guess.split(" ").each do |value|
                if after_shuffle==""
                    after_shuffle=after_shuffle + (value.split("").shuffle.join)
                    after_shuffle=after_shuffle + " "
                else
                    after_shuffle=after_shuffle + (value.split("").shuffle.join)
                end
            end
        else
            after_shuffle=guess.split("").shuffle.join
        end

        return after_shuffle
    end
    
end

class Answer < GameGuessingWord

    #mengkoreksi jawaban
    def self.check_answer(level,get_answer,set_answer)

        case get_answer==set_answer
        when true then Score.add_score(level)
        else Score.no_score
        end

    end
    
end

class Score < GameGuessingWord
    #penambahan score
    def self.add_score(level)
        score_helper = 0.0.to_f

        case level
        when 0 then
            score_helper =(15.0.to_f/@@all_levels_guesses[0].count).to_f
            @@score = @@score + (15.to_f/@@all_levels_guesses[0].count).to_f
        when 1 then
            score_helper =(35.0.to_f/@@all_levels_guesses[1].count).to_f
            @@score = @@score + (35.to_f/@@all_levels_guesses[1].count).to_f
        when 2 then
            score_helper =(50.0.to_f/@@all_levels_guesses[2].count).to_f
            @@score = @@score + (50.to_f/@@all_levels_guesses[2].count).to_f
        end

        puts "Benar, point anda bertambah #{score_helper.to_f}"
    end
    #tidak menambah score jika gagak
    def self.no_score
        puts "Salah, Silahkan coba lagi !"
    end
end

class MainProgram < GameGuessingWord
    
    @status_level=true

    #untuk petunjuk penggunaan game
    def self.gettingstarted
        system "clear"
        puts "######################################"
        puts "#    SELAMAT DATANG DI TEBAK KATA    #"
        puts "#                v.0.0.1             #"
        puts "######################################"
        puts "#                                    #"    
        puts "# Game ini memiliki 3 level.         #"
        puts "#  >> Level 1 memiliki nilai point   #\n#     maksimal 15                    #"
        puts "#  >> Level 2 memiliki nilai point   #\n#     maksimal 35                    #"
        puts "#  >> Level 3 memiliki nilai point   #\n#     maksimal 50                    #"
        puts "#                                    #"    
        puts "#------------------------------------#"    
        puts "#                                    #"    
        puts "# Game ini memiliki 3 peraturan.     #"
        puts "#  >> Level 1 wajib menggunakan 1    #\n#     kalimat.                       #"
        puts "#  >> Level 2 wajib menggunakan 2    #\n#     kalimat.                       #"
        puts "#  >> Level 3 wajib menggunakan 3    #\n#     kalimat.                       #"
        puts "#                                    #"    
        puts "#------------------------------------#"
        puts "#                                    #"    
        puts "#  * Game ini tidak memiliki batas   #\n#     pertanyaan                     #"
        puts "#                                    #"    
        puts "#------------------------------------#"
        gets.chomp()
    end
    
    #header aplikasi
    def self.header_program

        puts "######################################"
        puts "#    SELAMAT DATANG DI TEBAK KATA    #"
        puts "#                v.0.0.1             #"
        puts "######################################"
        puts ""

    end

    def self.header_answer
        puts "######################################"
        puts "-------------- LEVEL #{level_helper} ---------------"
        puts "Tombol * = Selesai tambah tebakan"
        puts "           untuk LEVEL #{level_helper}"
        puts "--------------------------------------"
        puts "######################################"
    end
    #processing penambahan level berdasarkan index
    def self.set_level(params)

        Guess.add_level(params)

        # index menjadi 0 karna penambahan pertanyaan pada level yang baru
        @@index=0
        @@guesses={}
    end
    
    #melakukan validasi syarat game dan proses untuk 
    #melanjutkan ke level berikut nya atau melanjutkan ke proses berikutnya
    def self.set_guess(level,set,clue)
        case set
        when "*" 
        then
            false
        else 
            Guess.validation_setter_guess(level,set)
            Guess.add_guess(@@index,set,clue)
            true
        end
    end

    #melakukan pengecekan dan penilai dari setiap jawaban
    def self.set_answer(level,get,set)
        Answer.check_answer(level,get,set)
    end

    #print hasil akhir dari game tebak kata
    def self.finish(score)
        
        if score>0
            puts "Selamat score anda #{score} !!" 
        else
            puts "Anda belum beruntung, silahkan coba lagi !"
        end
    end

    #running main program
    
    ##guide bermain
    gettingstarted

    #variable default
    @@level = 0
    level = 0
    level_helper=0

    #################################
    # perulangan untuk penambahan tebak tebakan
    #################################
        loop.with_index do |_,index|
            
            system "clear"
            header_program
            
            #level a.k.a index saat ini yang berfungsi untuk meneruskan proses selanjutnya
            if ((index == 3) || (@status_level==false))
                break
            end
            
            #untuk memudahkan leveling
            level_helper=level_helper + 1
            
            #memanggil view header answer
            header_answer
            
            ################################################
            # perulangan untuk penambahan tebak2 an
            ################################################
            loop.with_index do |_,index|
                
                puts "Pertanyaan #{index+1}"

                puts 'Tambah tebakanmu :'
                setter_guess=gets.chomp()

                break if (setter_guess=="*")

                puts 'Tambah petunjuk jawabannya :'
                setter_clue=gets.chomp()

                break if (setter_clue=="*")
                
                puts "--------------------------------------"
                
                break if set_guess(@@level,setter_guess,setter_clue)==false

                @@index= @@index+1
            end
            ################################################


            set_level(@@guesses)

            @@level = @@level +1
            level=level + 1
        end
    #################################

    #################################
    # perulangan untuk penambahan tebak tebakan
    #################################
        system "clear"
        header_program
        puts "============ SILAHKAN JAWAB =========="
        puts "======================================"
        level_helper=0
        
        @@all_levels_guesses.each do |index_level,object_level|
            level_helper=level_helper + 1
            puts "LEVEL #{level_helper} >> Total point saat ini #{@@score.round(2)}"
            puts "======================================"

            object_level.each do |index_values,values|
                puts "Pertanyaan #{index_values + 1}"

                puts "Tebak : #{values[0][:shuffle_guess]}"
                puts "Petunjuk : #{values[0][:clue]}"

                puts "Jawaban :"

                set_answer(index_level,values[0][:guess],gets.chomp())

                puts "======================================"
            end

        end
    #################################  


    #untuk menampilkan hasil akhir
    finish(@@score.round(2))
    
end