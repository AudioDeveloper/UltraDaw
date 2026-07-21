--PREFERENCES --
local my_prefs = renoise.Document.create("ScriptingToolPreferences") {
} 

--[[
===================================================================================================================================
===================================================================================================================================
===================================================================================================================================
===================================================================================================================================

                                                           START HERE

===================================================================================================================================
===================================================================================================================================
===================================================================================================================================
===================================================================================================================================
]]--

renoise.tool().preferences = my_prefs
renoise.tool():add_menu_entry
{
  name = "Main Menu:Tools:Ultradaw export",
  invoke = function() start_here() end 
}

local fudaw
local udaw_p1_file="udaw_parts\\xrns2udaw_p1.txt"
local udaw_p2_file="udaw_parts\\xrns2udaw_p2.txt"
local udaw_p3_file="udaw_parts\\xrns2udaw_p3.txt"

function get_track_index(_track)  
	-- number 1...
	assert(_track, "expected a valid track object")  
	for index, track in ipairs(renoise.song().tracks) do  
		if (rawequal(track, _track)) then   
			return index  
		end  
	end  
end  

function open_udaw()
	
	local fname=renoise.song().file_name..".upf"
	print(fname)
	fudaw = assert(io.open(fname, "w"))
end

function close_udaw()
	
	assert(fudaw:close())	
	
end

function write_udaw(stline)
	
	--print(stline)
	fudaw:write(stline, "\n")
	
end

function copy_part(src_name)
	local part_file
	part_file = assert(io.open(src_name, "r"))
	for line in part_file:lines() do 		--io.lines(part_file)
		write_udaw(line)
	end
	assert(part_file:close())	
end

function save_seq_trk(udaw_trkidx,track,grp_is)
	write_udaw("TRK_N="..string.format(udaw_trkidx))
	write_udaw("TRK_TYPE=2")
	write_udaw("TRK_NAME="..track.name)						
	write_udaw("TRK_COLO=00"..string.format("%02X",track.color[1])..string.format("%02X",track.color[2])..string.format("%02X",track.color[3]))
	write_udaw("TRK_H=60")
	write_udaw("TRK_W=231")
	if track.mute_state~=renoise.Track.MUTE_STATE_ACTIVE then
		write_udaw("TRK_FLAG=00000001")
	else
		write_udaw("TRK_FLAG=00000000")
	end
	write_udaw("TRK_VISI=_TRUE")
	write_udaw("TRK_EX1C=-1")
	write_udaw("TRK_EX2C=-1")
	write_udaw("TRK_EX1V=1.00000")
	write_udaw("TRK_EX2V=1.00000")
	write_udaw("TRK_MASTO=0")
	write_udaw("TRK_GRP="..grp_is)
	write_udaw("TRK_SENDQ=4")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")

	write_udaw("TRK_PAN="..string.format(math.floor(-127+(track.postfx_panning.value*254))))		--,string.format(trk_idx))			2d0
	write_udaw("TRK_VOL="..string.format(track.postfx_volume.value))
	write_udaw("TRK_PREPAN=0")
	write_udaw("TRK_PREVOL=1.00000")
	write_udaw("TRK_CHNS=2")
	write_udaw("TRK_MAND=0")
	write_udaw("TRKP_VSTI_IDX=-1")
	write_udaw("TRKP_VSTI_O1=0")
	write_udaw("TRKP_VSTI_O2=1")
	write_udaw("TRKP_VSTI_MIDIIN=1")
	write_udaw("TRKP_VSTI_OTRANS=0")
	write_udaw("TRKP_MIDI_DEV=")
	write_udaw("TRKP_MIDI_CHF=0")
	write_udaw("TRKP_MIDI_CHLN=0")
	write_udaw("TRKP_MIDI_CHHN=119")
	write_udaw("TRKP_MIDO_DEV=")
	write_udaw("TRKP_MIDO_CHN=1")
	write_udaw("TRKP_MIDO_TRNS=0")
	write_udaw("TRKP_MONOREC=_FALSE")
	write_udaw("TRKP_NCQ="..string.format(track.visible_note_columns))		-- колво нотных колонок
	write_udaw("TRKP_PCQ="..string.format(track.visible_effect_columns))	-- колво колонок параметров
	write_udaw("TRK_EVQ="..string.format(table.getn(renoise.song().patterns)))
end

function save_grp_trk(udaw_trkidx,track,grp_is)
	-- чистая группа
	write_udaw("TRK_N="..string.format(udaw_trkidx))
	write_udaw("TRK_TYPE=3")-- надо =3 для GRP
	write_udaw("TRK_NAME="..track.name)						
	write_udaw("TRK_COLO=00"..string.format("%02X",track.color[1])..string.format("%02X",track.color[2])..string.format("%02X",track.color[3]))
	write_udaw("TRK_H=60")
	write_udaw("TRK_W=231")
	if track.mute_state~=renoise.Track.MUTE_STATE_ACTIVE then
		write_udaw("TRK_FLAG=00000001")
	else
		write_udaw("TRK_FLAG=00000000")
	end
	write_udaw("TRK_VISI=_TRUE")
	write_udaw("TRK_EX1C=-1")
	write_udaw("TRK_EX2C=-1")
	write_udaw("TRK_EX1V=1.00000")
	write_udaw("TRK_EX2V=1.00000")
	write_udaw("TRK_MASTO=0")
	write_udaw("TRK_GRP="..grp_is)
	write_udaw("TRK_SENDQ=4")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")
	write_udaw("TRK_SEND=NOSEND")
	write_udaw("TRK_SENDV=1.00000")
	write_udaw("TRK_SENDPRE=_FALSE")

	write_udaw("TRK_PAN="..string.format(math.floor(-127+(track.postfx_panning.value*254))))		--,string.format(trk_idx))			2d0
	write_udaw("TRK_VOL="..string.format(track.postfx_volume.value))		--,string.format(trk_idx))	2d0
	write_udaw("TRK_PREPAN=0")
	write_udaw("TRK_PREVOL=1.00000")
	write_udaw("TRK_CHNS=2")
	write_udaw("TRK_MAND=0")
	write_udaw("TRKG_OPENED=_TRUE")
	write_udaw("TRKG_PCQ="..string.format(track.visible_effect_columns))	-- колво колонок параметров
	write_udaw("TRK_EVQ="..string.format(table.getn(renoise.song().patterns)))
end

function save_seq_pattern(glb_trkidx,seq_pat)
	local pt=seq_pat.tracks[glb_trkidx];			--renoise.PatternTrack
	local patevtq=0
	local one_note
	for _l, line in pairs(pt.lines) do   
		for _c, note_column in pairs(line.note_columns) do   
			if not note_column.is_empty then
				patevtq=patevtq+1
				one_note=string.format("%1X", _c-1)
				one_note=one_note..string.format("%03X", _l-1)
				if note_column.note_value~=121 then
					if note_column.note_value==120 then
						one_note=one_note.."NFF"
					else
						one_note=one_note.."N"..string.format("%02X",note_column.note_value+1)
					end
				end
				if  note_column.volume_value ~= renoise.PatternLine.EMPTY_VOLUME then
					if note_column.volume_value<=0x80 then
						one_note=one_note.."V"..string.format("%02X",note_column.volume_value)									
					else 
						if note_column.volume_value~=0xff then
							print("VOL "..note_column.volume_string)
						end
					end
				end
				
				if note_column.panning_value ~= renoise.PatternLine.EMPTY_PANNING then
					print("PAN "..note_column.panning_string)
				end

				if note_column.delay_value ~= renoise.PatternLine.EMPTY_DELAY then
					one_note=one_note.."D"..string.format("%02X",note_column.delay_value/2)
					print("DLY "..note_column.panning_string)
				end
				
				-- Check for sample effects
				if note_column.effect_number_value ~= renoise.PatternLine.EMPTY_EFFECT_NUMBER then
					print(note_column.effect_number_value)
				end
				
				if note_column.effect_amount_value ~= renoise.PatternLine.EMPTY_EFFECT_AMOUNT then
					print(note_column.effect_amount_value)
				end
--[[
renoise.song().patterns[].tracks[].lines[].note_columns[].note_value		  -> [number, 0-119, 120=Off, 121=Empty]
renoise.song().patterns[].tracks[].lines[].note_columns[].note_string		  -> [string, 'C-0'-'G-9', 'OFF' or '---']
renoise.song().patterns[].tracks[].lines[].note_columns[].instrument_value	  -> [number, 0-254, 255==Empty]
renoise.song().patterns[].tracks[].lines[].note_columns[].instrument_string	  -> [string, '00'-'FE' or '..']
renoise.song().patterns[].tracks[].lines[].note_columns[].volume_value		  -> [number, 0-127, 255==Empty when column value is <= 0x80 or is 0xFF, i.e. is used to specify volume]
																 [number, 0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2, when column value is > 0x80, i.e. is used to specify an effect]
renoise.song().patterns[].tracks[].lines[].note_columns[].volume_string		  -> [string, '00'-'ZF' or '..']
renoise.song().patterns[].tracks[].lines[].note_columns[].panning_value		  -> [number, 0-127, 255==Empty when column value is <= 0x80 or is 0xFF, i.e. is used to specify pan]
																 [number, 0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2, when column value is > 0x80, i.e. is used to specify an effect]
renoise.song().patterns[].tracks[].lines[].note_columns[].panning_string	  -> [string, '00'-'ZF' or '..']
renoise.song().patterns[].tracks[].lines[].note_columns[].delay_value		  -> [number, 0-255]
renoise.song().patterns[].tracks[].lines[].note_columns[].delay_string		  -> [string, '00'-'FF' or '..']
renoise.song().patterns[].tracks[].lines[].note_columns[].effect_number_value -> [int, 0-65535 in the form 0x0000xxyy where xx=effect char 1 and yy=effect char 2]
renoise.song().patterns[].tracks[].lines[].note_columns[].effect_number_string-> [string, '00' - 'ZZ']
renoise.song().patterns[].tracks[].lines[].note_columns[].effect_amount_value -> [int, 0-255]
renoise.song().patterns[].tracks[].lines[].note_columns[].effect_amount_string-> [string, '00' - 'FF']
]]--  
				write_udaw (one_note)
			end
			
		end  

	end
	write_udaw("---PRECS="..string.format(patevtq))
end


function save_patterns(glb_trkidx,track)		
	local patcolor
	-- паттерны трека
	for patidx, seq_pat in pairs(renoise.song().patterns) do   
			
		if renoise.song().patterns[patidx].tracks[glb_trkidx].color==nil then
			patcolor=string.format("%02X",track.color[1])..string.format("%02X",track.color[2])..string.format("%02X",track.color[3])
		else
			patcolor=string.format("%02X",renoise.song().patterns[patidx].tracks[glb_trkidx].color[1])..string.format("%02X",renoise.song().patterns[patidx].tracks[glb_trkidx].color[2])..string.format("%02X",renoise.song().patterns[patidx].tracks[glb_trkidx].color[3])
		end
		
		write_udaw("TRK_EVT="..string.format(patidx-1))
		write_udaw("TRK_EVT_N=")
		write_udaw("TRK_EVT_C=00"..patcolor)
		write_udaw("TRK_EVT_M=_FALSE")
		write_udaw("TRK_EVT_B=0")
		write_udaw("TRK_EVT_E=0")
		write_udaw("PAT_IDX="..string.format(patidx-1))
		write_udaw("PAT_COLOR=00"..patcolor)
		write_udaw("PAT_MUTED=_FALSE")
		
		if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
			save_seq_pattern(glb_trkidx,seq_pat)
		end  --only seq
		write_udaw("---PPRECS=0")		
	end -- patterns
	write_udaw("TRK_VCH_LEN=0")
end		


function replace_char(pos, str, r)
	return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

function save_tempos()
	local pt
	local patevtq
	local one_note

	for glb_trkidx, track in ipairs(renoise.song().tracks) do
		for patidx, seq_pat in pairs(renoise.song().patterns) do   

			pt=seq_pat.tracks[glb_trkidx];			--renoise.PatternTrack
			patevtq=0
			for _l, line in pairs(pt.lines) do   
				for _c, fx_column in pairs(line.effect_columns) do   
					if not fx_column.is_empty then
						if fx_column.number_string=="ZT" then
							print("TEMPO ="..string.format(fx_column.amount_value))
						else
							print("CMD===> "..fx_column.number_string.." "..fx_column.amount_string)
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------


function start_here()
	local trk,seq_len,line, trk_q
	
	local tempo_tpq=480
	local tpos
	local stop_pos
	local s2t
	print("=============================")
	save_tempos()
	
	--local fil
	open_udaw()

	copy_part(udaw_p1_file)
	write_udaw("TTEMPO_META="..string.format(4))
	write_udaw("TTEMPO_METB="..string.format(4))
	write_udaw("TTEMPO_FOLLOW=_TRUE")
	write_udaw("TTEMPO_UNITS=0")

	write_udaw("TEMPOTRK_EVQ="..string.format(1))	--tempo evt q
	
	for tempo_idx=1, 1 do
		write_udaw("TRK_EVT=0") --..string.format(tempo_idx-1))
		write_udaw("TRK_EVT_N=")
		write_udaw("TRK_EVT_C=00ff00ff")
		write_udaw("TRK_EVT_M=_FALSE")
		write_udaw("TRK_EVT_B=0") --..string.format(tempo_idx-1.pos))
		write_udaw("TRK_EVT_E=1") --..string.format(tempo_idx-1.pos+1))
		write_udaw("TEMPOTRK_TPOS=0") -- ..string.format(patidx-1))
		write_udaw("TEMPOTRK_TEMPO="..string.format(renoise.song().transport.bpm))
		s2t=(48000*60)/(renoise.song().transport.bpm*tempo_tpq)
		write_udaw("TEMPOTRK_S2T="..string.format(s2t))			--TEMPOTRK_S2T=AUDIO_DRV_SAMPLERATE*60/TEMPOTRK_TEMPO*TTEMPO_TPQ
	end
	
	trk_q=0		--сколько треков переносим
	for idx, track in ipairs(renoise.song().tracks) do
		if track.type == renoise.Track.TRACK_TYPE_SEQUENCER or track.type == renoise.Track.TRACK_TYPE_GROUP then
			trk_q=trk_q+1
		end
	end

	-- но
	local udaw_trk_nums ={}		-- индекс группа renoise, содержимое - моя группа
	for i=1, trk_q do
		udaw_trk_nums[i] = -1
    end
	
	local grp_parent={}
	local gpr_trk
	local gpr_trk_q
	local grp_real_idx
	local grp_is

	--write_udaw("TEMPOTRK_TEMPO="..string.format(renoise.song().transport.bpm))
	--local s2t=(48000*60)/(renoise.song().transport.bpm*tempo_tpq)
	--write_udaw("TEMPOTRK_S2T="..string.format(s2t))			--TEMPOTRK_S2T=AUDIO_DRV_SAMPLERATE*60/TEMPOTRK_TEMPO*TTEMPO_TPQ

	--calc stop pos
	tpos=0
	for _, seq_step in pairs(renoise.song().sequencer.pattern_sequence) do
		tpos=tpos+(tempo_tpq/renoise.song().transport.lpb)*renoise.song().patterns[seq_step].number_of_lines
	end
			
	stop_pos=math.floor(s2t*tpos+0.5)
	write_udaw("SONG_STOP="..string.format(stop_pos))
	
	copy_part(udaw_p2_file)
	write_udaw("MTRED_SHOW_E="..string.format(stop_pos))
	
	copy_part(udaw_p3_file)
	write_udaw("TRKS="..string.format(trk_q))
	local udaw_trkidx=0
	for glb_trkidx, track in ipairs(renoise.song().tracks) do
		if track.type == renoise.Track.TRACK_TYPE_MASTER then break end
		
		-- разбор групп
		if track.group_parent==nil then
			grp_is="NOGRP"
		else
			gpr_trk=track.group_parent		--первая родительская группа
			gpr_trk_q=1
			grp_parent[gpr_trk_q]=gpr_trk
			while gpr_trk.group_parent~=nil do
				gpr_trk_q=gpr_trk_q+1
				gpr_trk=gpr_trk.group_parent
				grp_parent[gpr_trk_q]=gpr_trk
			end
			
			-- создание групп от более высокой к более низкой
			for i=gpr_trk_q,1,-1 do						
				grp_real_idx=get_track_index(grp_parent[i])		-- номер grp в renoise
				local parent_idx
				
				
				if udaw_trk_nums[grp_real_idx]==-1 then
					-- группа еще не создана у меня. записать группу с указанием родителя
					udaw_trk_nums[grp_real_idx]=udaw_trkidx
					if grp_parent[i].group_parent==nil then 
						parent_idx="NOGRP"
					else
						parent_idx=string.format(udaw_trk_nums[get_track_index(grp_parent[i].group_parent)])
					end
						
					print("------------------------------------ GRP (moved) "..grp_parent[i].name)
					print("R("..grp_real_idx..") U("..udaw_trkidx..") parent - "..parent_idx)
					
					save_grp_trk(udaw_trkidx,grp_parent[i],  parent_idx)
					save_patterns(grp_real_idx,grp_parent[i])
					udaw_trkidx=udaw_trkidx+1
					
				end
			end
			
			grp_is=string.format(udaw_trk_nums[get_track_index(grp_parent[1])])
			
		end

		-- запись трека
		
		if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then

			print("------------------------------------ TRACK SEQ "..track.name)
			print("R("..glb_trkidx..") U("..udaw_trkidx..") parent - "..grp_is)
			udaw_trk_nums[glb_trkidx]=udaw_trkidx
			save_seq_trk(udaw_trkidx,track,grp_is)
			save_patterns(glb_trkidx,track)
			udaw_trkidx=udaw_trkidx+1

		elseif track.type == renoise.Track.TRACK_TYPE_GROUP and udaw_trk_nums[glb_trkidx]==-1 then

			print("------------------------------------ TRACK GRP "..track.name)
			print("R("..glb_trkidx..") U("..udaw_trkidx..") parent - "..grp_is)
			udaw_trk_nums[glb_trkidx]=udaw_trkidx
			save_grp_trk(udaw_trkidx,track,grp_is)
			save_patterns(glb_trkidx,track)
			udaw_trkidx=udaw_trkidx+1

		end
	end	--for tracks

	local enabler

	write_udaw("VSTI_Q=0")
	write_udaw("MODSEQ_Q=".. string.format(table.getn(renoise.song().sequencer.pattern_sequence)))
	write_udaw("MODSEQ_EVTQ="..string.format(table.getn(renoise.song().patterns)))
	tpos=0
	--пройдемся по Seq
	for seq_idx, pat_idx in pairs(renoise.song().sequencer.pattern_sequence) do
		write_udaw("MODSEQ_STEP_IDX="..pat_idx-1)	--номер паттерна 1... (а внутри renoise показывает 0...
		write_udaw("MODSEQ_STEP_L="..renoise.song().patterns[pat_idx].number_of_lines)
		write_udaw("MODSEQ_STEP_LPB="..renoise.song().transport.lpb)
		write_udaw("MODSEQ_STEP_POS="..string.format(tpos))
		write_udaw("MODSEQ_STEP_COLOR=8032423")
		write_udaw("MODSEQ_STEP_NAME="..renoise.song().patterns[pat_idx].name)
	
		--enabler - задом наперед (первый трек - последним) плюс еще учитывай, что изменилась нумерация, за счет переноса групп
		enabler=""
		for i=1,trk_q do enabler=enabler.."1" end
		for i=1,trk_q do		
			
			if renoise.song().sequencer:track_sequence_slot_is_muted(i, seq_idx) then
				enabler=replace_char(trk_q-udaw_trk_nums[i], enabler, "0")
				-- str:sub(1, pos-1) .. r .. str:sub(pos+1)
			end
		end
		write_udaw("MODSEQ_STEP_ENABLER="..enabler)
		tpos=tpos+(tempo_tpq/renoise.song().transport.lpb)*renoise.song().patterns[pat_idx].number_of_lines
	end

	write_udaw("MODREC_QUANT=_TRUE")
	write_udaw("MODREC_QUANT_L=1")
	write_udaw("MOD_VIEWMODE=0")
	write_udaw("MODPATED_LINEH=0")
	write_udaw("MOD_SMP_FOUT=10")
	write_udaw("MODPATED_VIEWONE=_FALSE")
	write_udaw("MODPATED_VIEWCOLS=14")
	write_udaw("MODSEQED_CELLDX=20")
	write_udaw("MODSEQED_CELLDY=20")
	write_udaw("MODSEQED_LEFTDX=121")
	write_udaw("MODSEQED_FONT_W=8")
	write_udaw("MODSEQED_FONT_H=12")
	write_udaw("MODSEQED_FONT=0")
	write_udaw("MODSEQED_BASEOCT=4")
	write_udaw("MODSEQED_LINESTEP=1")
	write_udaw("MODPATED_COMPKEYS_VEL=96")
	write_udaw("MODPATED_COMPKEYS_VELUSE=_TRUE")
	write_udaw("MODSEQED_HEXLN=_FALSE")
	write_udaw("MODSEQED_OPT_CDEL_VST=_TRUE")
	write_udaw("MODSEQED_OPT_CDEL_VSTI=_TRUE")
	write_udaw("MODSEQED_OPT_CDEL_INSTR=_TRUE")
	write_udaw("MODSEQED_ACT=0")
	write_udaw("MODREC_REC_NOTEOFF=_TRUE")
	write_udaw("MODSEQED_TRANSHOW=52")
	write_udaw("MOD_TRACEPTRN=_TRUE")
	write_udaw("PATED_WVFADES=_FALSE")
	write_udaw("PATED_TW_WV=85")
	write_udaw("PATED_TW_MI=85")
	write_udaw("PATED_TW_NT=85")
	write_udaw("PATED_TW_AM=85")
	write_udaw("IPQ=0")
	write_udaw("USED_INSTR=0")
	write_udaw("MAPPERS_UQ=0")
	write_udaw("MAPPERS_UA=0")
	write_udaw("MDILINKS_Q=1")
	write_udaw("MDOLINKS_Q=1")
	write_udaw("MDI_NAME=ComputerKeys virt dev")
	write_udaw("MDO_NAME=Microsoft GS Wavetable Synth")

	close_udaw()


end

