/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele;

import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMapping;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactoryDlg;

public class MF4HModelFactoryDlg extends MFModelFactoryDlg {

	public MViewModelImpl createViewModel(String p_sName, String p_sUmlName, MPackage p_oPackage, ViewModelType p_sType, MEntityImpl p_oEntityToUpdate, String p_sPath, boolean p_bCustomizable) {
		return new MF4HViewModel(p_sName, p_sUmlName, p_oPackage, p_sType, p_oEntityToUpdate, p_sPath, p_bCustomizable, new MMapping());
	}
}
