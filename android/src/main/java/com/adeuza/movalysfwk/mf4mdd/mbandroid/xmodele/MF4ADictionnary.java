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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele;

import java.util.Collection;

import com.a2a.adjava.languages.android.xmodele.MAndroidDictionnary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDataLoaderDictionaryDlg;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;

/**
 * Dictionary for MF4 android
 * @author lmichenaud
 *
 */
public class MF4ADictionnary extends MAndroidDictionnary implements MFModelDictionary {

	/**
	 * Dictionary delegate for dataloder
	 */
	private MFDataLoaderDictionaryDlg dataLoaderDlg = new MFDataLoaderDictionaryDlg();
	
	/**
	 * @param p_sName
	 * @param p_oDataLoader
	 */
	public void registerDataLoader(MDataLoader p_oDataLoader ) {
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
	 * Return the <code>DataLoader</code> that match to the current name send as parameter.
	 * @param p_sName the name of the DataLoader
	 * @return object of type <code>MDataLoader</code>
	 */
	public MDataLoader getDataLoader(String p_sName) {
		return this.dataLoaderDlg.getDataLoader(p_sName);
	}
}
