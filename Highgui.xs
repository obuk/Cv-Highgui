/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

typedef vector<int> intV;
typedef vector<uchar> ucharV;

static void cb_trackbar2(int pos, VOID* userdata)
{
	callback_t *p = (callback_t*)userdata;
	if (!p) return;
	if (p->u.t.pos == p->u.t.lastpos) return;
	if (p->u.t.value) sv_setiv(p->u.t.value, p->u.t.pos);
	if (p->callback) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		EXTEND(SP, 5);
		PUSHs(sv_2mortal(newSViv(p->u.t.pos)));
		PUSHs(p->u.m.userdata? p->u.t.userdata : &PL_sv_undef);
		PUTBACK;
		call_sv(p->callback, G_DISCARD);
		FREETMPS;
		LEAVE;
	}
	p->u.t.lastpos = p->u.t.pos;
}

static CvMat* matToCvmat(Mat& var)
{
	CvMat* cvmat = cvCreateMatHeader(var.rows, var.cols, var.type());
	cvSetData(cvmat, var.data, CV_AUTOSTEP);
	var.addref();
	return cvmat;
}

MODULE = Cv::Highgui		PACKAGE = Cv::Highgui		

# C++:  int createTrackbar(const string& trackbarname, const string& winname, int* value, int count, TrackbarCallback onChange=0, void* userdata=0)

int
createTrackbar(const char* trackbarName, const char* windowName, SV* value, int count, SV* onChange=NO_INIT, SV* userdata=NO_INIT)
PREINIT:
	callback_t* callback;
	HV* Cv_TRACKBAR;
	SV** q; AV* av; SV* sv;
INIT:
	if (items < 5) onChange = (SV*)0;
	if (items < 6) userdata = (SV*)0;
	if (!(Cv_TRACKBAR = get_hv("Cv::TRACKBAR", 0))) {
		Perl_croak(aTHX_ "Cv::Highgui::createTrackbar: can't get \%Cv::TRACKBAR");
	}
	RETVAL = -1;
CODE:
	Newx(callback, 1, callback_t);
	callback->callback = 0;
	if (onChange && SvROK(onChange) && SvTYPE(SvRV(onChange)) == SVt_PVCV) {
		SvREFCNT_inc(callback->callback = (SV*)SvRV(onChange));
	}
	callback->u.t.userdata = 0;
	if (userdata) {
		SvREFCNT_inc(callback->u.t.userdata = userdata);
	}
	callback->u.t.value = 0;
	callback->u.t.lastpos = callback->u.t.pos = 0;
	if (SvOK(value) && SvTYPE(value) == SVt_IV) {
		SvREFCNT_inc(callback->u.t.value = value);
		callback->u.t.lastpos = callback->u.t.pos = SvIV(value);
	}
	RETVAL = createTrackbar(trackbarName, windowName,
				&callback->u.t.pos, count, cb_trackbar2, callback);
	q = hv_fetch(Cv_TRACKBAR, windowName, strlen(windowName), 0);
	if (q && SvROK(*q) && SvTYPE(SvRV(*q)) == SVt_PVAV) { SV* sv;
		av = (AV*)SvRV(*q);
	} else if (!q) {
		av = newAV();
		hv_store(Cv_TRACKBAR, windowName, strlen(windowName),
			newRV_inc(sv_2mortal((SV*)av)), 0);
	} else {
		Perl_croak(aTHX_ "Cv::Highgui::createTrackbar: Cv::TRACKBAR was broken");
	}
	av_push(av, newSViv(PTR2IV(callback)));
OUTPUT:
	RETVAL


MODULE = Cv::Highgui		PACKAGE = Cv::Highgui		

BOOT:
	{
	}
