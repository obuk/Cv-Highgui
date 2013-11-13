/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

typedef vector<int> intV;
typedef vector<uchar> ucharV;

static CvMat* matToCvmat(Mat& var)
{
	CvMat* cvmat = cvCreateMatHeader(var.rows, var.cols, var.type());
	cvSetData(cvmat, var.data, CV_AUTOSTEP);
	var.addref();
	return cvmat;
}

MODULE = Cv::Highgui		PACKAGE = Cv::Highgui		
