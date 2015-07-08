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
package com.adeuza.movalysfwk.mf4mdd.ios.xmodele;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import com.a2a.adjava.languages.ios.xmodele.MIOSDictionnary;
import com.a2a.adjava.languages.ios.xmodele.views.MIOSSection;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDataLoaderDictionaryDlg;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;

/**
 * Dictionary for MF4IOS
 * @author lmichenaud
 *
 */
public class MF4IDictionnary extends MIOSDictionnary implements MFModelDictionary {

	/**
	 * Dataloader dictionary delegate
	 */
	private MFDataLoaderDictionaryDlg dataLoaderDlg = new MFDataLoaderDictionaryDlg();
			
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary#registerDataLoader(com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader)
	 */
	@Override
	public void registerDataLoader(MDataLoader p_oDataLoader) {
		this.dataLoaderDlg.registerDataLoader(p_oDataLoader);
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary#getAllDataLoaders()
	 */
	@Override
	public Collection<MDataLoader> getAllDataLoaders() {
		return this.dataLoaderDlg.getAllDataLoaders();
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary#getDataLoader(java.lang.String)
	 */
	@Override
	public MDataLoader getDataLoader(String p_sName) {
		return this.dataLoaderDlg.getDataLoader(p_sName);
	}

	/**
	 * Return section having viewmodel
	 * @param p_oViewModel viewmodel
	 * @return section having viewmodel
	 */
	public List<MIOSSection> getAllIOSSectionByViewModel(MViewModelImpl p_oViewModel) {
		List<MIOSSection> r_oAllSections = new ArrayList<MIOSSection>();
		for( MIOSSection oSection : this.getAllIOSSections()) {
			if ( oSection.getViewModel() != null && oSection.getViewModel().equals(p_oViewModel.getMasterInterface().getName())) {
				r_oAllSections.add( oSection ) ;
			}
		}
		return r_oAllSections;
	}
}
