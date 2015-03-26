#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Wed Mar 25 16:54:43 2015
##################################################

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"

from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import uhd
from gnuradio import wxgui
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from gnuradio.wxgui import scopesink2
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import ettus
import wx

class top_block(grc_wxgui.top_block_gui):

    def __init__(self):
        grc_wxgui.top_block_gui.__init__(self, title="Top Block")

        ##################################################
        # Variables
        ##################################################
        self.device3 = variable_uhd_device3_0 = ettus.device3(uhd.device_addr_t( ",".join(("type=x300", "addr=192.168.10.2")) ))
        self.samp_rate = samp_rate = 20e6

        ##################################################
        # Blocks
        ##################################################
        self.wxgui_scopesink2_0_0 = scopesink2.scope_sink_c(
        	self.GetWin(),
        	title="Scope Plot",
        	sample_rate=samp_rate,
        	v_scale=0,
        	v_offset=0,
        	t_scale=0,
        	ac_couple=False,
        	xy_mode=False,
        	num_inputs=1,
        	trig_mode=wxgui.TRIG_MODE_AUTO,
        	y_axis_label="Counts",
        )
        self.Add(self.wxgui_scopesink2_0_0.win)
        self.wxgui_scopesink2_0 = scopesink2.scope_sink_c(
        	self.GetWin(),
        	title="Scope Plot",
        	sample_rate=samp_rate,
        	v_scale=0,
        	v_offset=0,
        	t_scale=0,
        	ac_couple=False,
        	xy_mode=False,
        	num_inputs=1,
        	trig_mode=wxgui.TRIG_MODE_AUTO,
        	y_axis_label="Counts",
        )
        self.Add(self.wxgui_scopesink2_0.win)
        self.uhd_rfnoc_streamer_schmidlcox_0 = ettus.rfnoc_generic(
            self.device3,
            uhd.stream_args( # TX Stream Args
                cpu_format="fc32", # TODO: This must be made an option
                otw_format="sc16",
                channels=(0,),
                args="",
            ),
            uhd.stream_args( # RX Stream Args
                cpu_format="fc32",
                otw_format="sc16",
                channels=(0,),
                args="",
            ),
            "SchmidlCox", -1, -1,
        )
        self.uhd_rfnoc_streamer_schmidlcox_0.set_register(0x10, 64) # Frame length
        self.uhd_rfnoc_streamer_schmidlcox_0.set_register(0x11, 16) # CP length
        self.uhd_rfnoc_streamer_schmidlcox_0.set_register(0x12, 22) # samples to wait after trigger
        self.uhd_rfnoc_streamer_schmidlcox_0.set_register(0x13, 2) # max number of frames to process
        self.uhd_rfnoc_streamer_fft_0 = ettus.rfnoc_generic(
            self.device3,
            uhd.stream_args( # TX Stream Args
                cpu_format="fc32", # TODO: This must be made an option
                otw_format="sc16",
                args="spp=64,magnitude_out=0",
            ),
            uhd.stream_args( # RX Stream Args
                cpu_format="fc32", # TODO: This must be made an option
                otw_format="sc16",
                args="",
            ),
            "FFT", -1, -1,
        )
        self.blocks_vector_to_stream_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, 64)
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_gr_complex*1, samp_rate,True)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_gr_complex*1, "/home/julian/git/ofdm-sync/octave-sym/test-float.bin", True)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_gr_complex*1, "/home/julian/Desktop/output.bin", False)
        self.blocks_file_sink_0.set_unbuffered(True)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_file_source_0, 0), (self.blocks_throttle_0, 0))    
        self.connect((self.blocks_throttle_0, 0), (self.wxgui_scopesink2_0, 0))    
        self.connect((self.blocks_vector_to_stream_0, 0), (self.blocks_file_sink_0, 0))    
        self.connect((self.blocks_vector_to_stream_0, 0), (self.wxgui_scopesink2_0_0, 0))    
        self.connect((self.blocks_throttle_0, 0), (self.uhd_rfnoc_streamer_schmidlcox_0, 0))    
        self.connect((self.uhd_rfnoc_streamer_fft_0, 0), (self.blocks_vector_to_stream_0, 0))    
        self.device3.connect(self.uhd_rfnoc_streamer_schmidlcox_0.get_block_id(), 0, self.uhd_rfnoc_streamer_fft_0.get_block_id(), 0)    


    def get_variable_uhd_device3_0(self):
        return self.variable_uhd_device3_0

    def set_variable_uhd_device3_0(self, variable_uhd_device3_0):
        self.variable_uhd_device3_0 = variable_uhd_device3_0

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)
        self.wxgui_scopesink2_0.set_sample_rate(self.samp_rate)
        self.wxgui_scopesink2_0_0.set_sample_rate(self.samp_rate)


if __name__ == '__main__':
    parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
    (options, args) = parser.parse_args()
    tb = top_block()
    tb.Start(True)
    tb.Wait()
