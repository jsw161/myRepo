<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR" import="java.util.ArrayList" import="le.Lecture"
	import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>JSP</title>
<%! Lecture lectures[] = new Lecture[100];
	ArrayList<String> tt = new ArrayList<String>();
	int num = 0;
	ArrayList<ArrayList<Lecture>> list = new ArrayList<ArrayList<Lecture>>();
	String selection[] = new String[2];

	public void SetLecture(String path) {
		File file = new File(path);
		String x;
		String input[] = { "", "", "", "" };
		try {
			BufferedReader reader = new BufferedReader(new FileReader(file));
			while (true) {
				lectures[num] = new Lecture();
				x = reader.readLine();
				if (x.equals("")) {
					break;
				} else {
					input = x.split("-");
					String time_[] = input[2].split(",");

					int time[] = new int[time_.length];
					for (int i = 0; i < time_.length; i++) {
						time[i] = Integer.parseInt(time_[i]);
					}
					lectures[num].setSubjectCode(input[0]);
					lectures[num].setName(input[1]);
					lectures[num].setLectureTime(time);
					int k = 0;
					try {
						k = Integer.parseInt(input[3]);
					} catch (Exception e) {
					}

					lectures[num].setSubNum(k);
					num++;
				}
			}
			reader.close();
		} catch (Exception e) {
		}
	}

	public boolean compareTime(int a[], int b[]) {
		int aNum = a.length, bNum = b.length;
		int aPosi = 0, bPosi = 0;
		boolean isPossible = true;

		for (int i = 0; i < aNum + bNum; i++) {
			if (a[aPosi] < b[bPosi]) {
				aPosi++;
			} else if (a[aPosi] > b[bPosi]) {
				bPosi++;
			} else {
				isPossible = false;
				break;
			}
			if (aPosi == aNum || bPosi == bNum) {
				break;
			}
		}
		return isPossible;
	}

	public void FindCombination(ArrayList<ArrayList<Lecture>> list, int depth,
			int width, ArrayList<Lecture> time) {
		Lecture curLecture = list.get(depth).get(width);
		

		if (depth == list.size() - 1) {
			time.add(curLecture);
			tt.add(CopyToString(time));
			time.remove(curLecture);
			return;
		} else {
			for (int i = 0; i < list.get(depth + 1).size(); i++) {
				if (compareTime(curLecture.getLectureTime(), list
						.get(depth + 1).get(i).getLectureTime())) {
					time.add(curLecture);
					FindCombination(list, depth + 1, i, time);
					time.remove(curLecture);
				}
			}
			return;
		}
	}

	public void Execute(ArrayList<ArrayList<Lecture>> list) {
		for (int i = 0; i < list.get(0).size(); i++) {
			ArrayList<Lecture> timetable = new ArrayList<Lecture>();
			FindCombination(list, 0, i, timetable);
		}
	}

	public String CopyToString(ArrayList<Lecture> list) {
		String result = "";
		for (int i = 0; i < list.size(); i++) {
			result = result + list.get(i).getSubjectCode() + "-"
					+ list.get(i).getSubNum() + " ";
		}
		return result;
	}%>
	<%
		request.setCharacterEncoding("EUC-KR");
		selection[0] = request.getParameter("sub1");
		selection[1] = request.getParameter("sub2");
		String k = application.getRealPath("/WEB-INF/abc.txt");
		SetLecture(k);
		for (int i = 0; i < 2; i++) {
			list.add(new ArrayList<Lecture>());
		}
		for (int i = 0; i < num; i++) {
			String subCode = lectures[i].getSubjectCode();
			for (int j = 0; j < 2; j++) {
				if (subCode.equals(selection[j])) {
					list.get(j).add(lectures[i]);
					break;
				}
			}
		}
		
		//알고리즘 실행
		Execute(list);

		for (int i = 0; i < tt.size(); i++) {
			String x = tt.get(i);
			out.println(x + "<BR>");
		}
	%>

</head>
<body>
	test
</body>
</html>